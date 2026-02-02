import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:mobile/utils/url_utils.dart';

final liveMatchServiceProvider = Provider<LiveMatchService>((ref) {
  return LiveMatchService();
});

class LiveMatchService {
  WebSocketChannel? _channel;
  // Broadcast stream to allow multiple listeners
  final _eventController = StreamController<Map<String, dynamic>>.broadcast();
  bool _isConnected = false;
  bool _isConnecting = false;

  // Reconnection logic
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 3);

  Stream<Map<String, dynamic>> get events => _eventController.stream;
  bool get isConnected => _isConnected;

  void connect() {
    // If already connected or connecting, don't do anything
    if (_isConnected || _isConnecting) return;

    _isConnecting = true;
    final wsUrl = _getWebSocketUrl();
    print('[WS] Connecting to $wsUrl');

    try {
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _isConnected = true;
      _isConnecting = false;
      _reconnectAttempts = 0; // Reset attempts on successful connection initiated

      _channel!.stream.listen(
        (message) {
          print('[WS] Received: $message');
          try {
             // Handle 'Connection established' or json messages
             if (message == 'Connection established') {
               _sendSubscription();
               return;
             }

             try {
                final decoded = jsonDecode(message);
                _eventController.add(decoded);
             } catch (_) {
               // Ignore non-json messages
               print('[WS] Received non-JSON message: $message');
             }
          } catch (e) {
            print('[WS] Error decoding message: $e');
          }
        },
        onError: (error) {
          print('[WS] Error: $error');
          _cleanup();
          _scheduleReconnect();
        },
        onDone: () {
          print('[WS] Connection closed');
          _cleanup();
          _scheduleReconnect();
        },
      );

      // Send subscription message immediately upon connection attempt
      // The server might need a moment, handled by 'Connection established' check above
      // But sending it here too just in case
      _sendSubscription();

    } catch (e) {
      print('[WS] Connection failed: $e');
      _cleanup();
      _scheduleReconnect();
    }
  }

  /// Force reconnection to WebSocket
  void forceReconnect() {
    print('[WS] Force reconnecting...');
    _reconnectAttempts = 0;
    disconnect();
    connect();
  }

  void _sendSubscription() {
    if (_channel != null) {
      final subscriptionMsg = jsonEncode({'action': 'subscribe_all'});
      print('[WS] Sending subscription: $subscriptionMsg');
      try {
        _channel!.sink.add(subscriptionMsg);
      } catch (e) {
         print('[WS] Error sending subscription: $e');
      }
    }
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts < _maxReconnectAttempts) {
      _reconnectAttempts++;
      final delay = _reconnectDelay * _reconnectAttempts;
      print('[WS] Scheduling reconnect attempt $_reconnectAttempts in ${delay.inSeconds}s');

      _reconnectTimer?.cancel();
      _reconnectTimer = Timer(delay, () {
        print('[WS] Attempting to reconnect...');
        connect();
      });
    } else {
      print('[WS] Max reconnect attempts reached. Giving up.');
    }
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    if (_isConnected) {
      print('[WS] Disconnecting manually');
      _channel?.sink.close();
      _cleanup();
    }
  }

  void _cleanup() {
    _isConnected = false;
    _isConnecting = false;
    _channel = null;
  }

  String _getWebSocketUrl() {
    // We already have UrlUtils but it seems it is for HTTP
    // Let's adapt it or just reproduce logic here for WS

    // Front-end reference: ws://localhost:8080/ws

    // Determine host based on platform
    String host = 'localhost';
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        host = '10.0.2.2';

        // Check if running on physical device (this is a simple heuristic)
        // If you need physical device support, you might need configuration
        // host = '192.168.1.X';
      }
    }

    return 'ws://$host:8080/ws';
  }

  void dispose() {
    _eventController.close();
    disconnect();
  }
}

