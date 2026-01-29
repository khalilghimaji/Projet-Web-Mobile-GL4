import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart' as api;
import 'package:mobile/providers/api_providers.dart';
import 'package:mobile/providers/notifications_provider.dart';
import 'package:dio/dio.dart';
import 'package:built_collection/built_collection.dart';
import 'package:one_of/any_of.dart';

// Provider for the realtime updates service
final realtimeUpdatesServiceProvider = Provider<RealtimeUpdatesService>((ref) {
  final dio = ref.watch(dioProvider);
  final authState = ref.watch(authStateProvider);
  return RealtimeUpdatesService(dio, ref, authState);
});

class RealtimeUpdatesService {
  final Dio _dio;
  final Ref _ref;
  AuthState _authState;
  late final NotificationsNotifier _notificationsNotifier;
  late final UserDataNotifier _userDataNotifier;

  StreamSubscription<String>? _sseSubscription;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;
  Timer? _reconnectTimer;

  RealtimeUpdatesService(this._dio, this._ref, this._authState) {
    // Store reference to notifier to avoid Riverpod ref issues in async callbacks
    _notificationsNotifier = _ref.read(notificationsProvider.notifier);
    _userDataNotifier = _ref.read(userDataProvider.notifier);

    // Start connection if authenticated
    if (_authState.isAuthenticated && _authState.accessToken != null) {
      print(
        '[SSE] Initializing with authenticated user, starting SSE connection',
      );
      _connectSSE();
    } else {
      print(
        '[SSE] Initializing without authentication, SSE connection will start when user logs in',
      );
    }
  }

  void updateAuthenticationStatus(AuthState authState) {
    final wasAuthenticated = _authState.isAuthenticated;
    _authState = authState;

    print(
      '[SSE] Authentication status changed: ${authState.isAuthenticated} (was $wasAuthenticated)',
    );

    if (authState.isAuthenticated &&
        authState.accessToken != null &&
        _sseSubscription == null) {
      print(
        '[SSE] User authenticated with valid token, starting SSE connection',
      );
      _connectSSE();
    } else if (!authState.isAuthenticated || authState.accessToken == null) {
      print('[SSE] User logged out or token invalid, disconnecting SSE');
      _disconnectSSE();
    }
  }

  void _connectSSE() {
    if (_sseSubscription != null ||
        !_authState.isAuthenticated ||
        _authState.accessToken == null) {
      if (!_authState.isAuthenticated) {
        print('[SSE] Cannot connect: User not authenticated');
        return;
      }
      if (_authState.accessToken == null) {
        print('[SSE] Cannot connect: No access token available');
        return;
      }
      if (_sseSubscription != null) {
        print('[SSE] Cannot connect: SSE subscription already exists');
        return;
      }
      return;
    }

    _shouldReconnect = true;
    // Don't reset _reconnectAttempts here - only reset on successful connection

    print('[SSE] Attempting to connect to SSE stream with authentication...');

    try {
      // Get the base URL from Dio options and construct full SSE URL
      final baseUrl = _dio.options.baseUrl;
      final sseUrl = baseUrl.endsWith('/')
          ? '${baseUrl}notifications/sse'
          : '$baseUrl/notifications/sse';

      print('[SSE] Connecting to SSE URL: $sseUrl');

      // Create SSE stream using Dio (authentication headers will be added automatically by interceptor)
      final request = RequestOptions(
        path: sseUrl,
        method: 'GET',
        responseType: ResponseType.stream,
      );

      _dio
          .fetch(request)
          .then((response) {
            if (response.data is ResponseBody) {
              final responseBody = response.data as ResponseBody;
              // Convert the byte stream to string stream and split lines
              _sseSubscription = responseBody.stream
                  .map((bytes) => utf8.decode(bytes))
                  .transform(LineSplitter())
                  .listen(
                    _handleSSEMessage,
                    onError: _handleSSEError,
                    onDone: _handleSSEDone,
                    cancelOnError: false,
                  );

              print(
                '[SSE] Successfully connected to SSE stream with authentication',
              );

              // Update notifications connection status
              _notificationsNotifier.updateConnectionStatus(true);
            }
          })
          .catchError((error) {
            print('[SSE] Failed to connect to SSE stream: $error');
            _handleSSEError(error);
          });
    } catch (error) {
      print('[SSE] Exception during SSE connection setup: $error');
      _handleSSEError(error);
    }
  }

  void _disconnectSSE() {
    print('[SSE] Disconnecting from SSE stream');
    _shouldReconnect = false;
    _reconnectTimer?.cancel();

    if (_sseSubscription != null) {
      _sseSubscription!.cancel();
      _sseSubscription = null;
      print('[SSE] SSE subscription cancelled');
    }

    // Update notifications connection status
    _notificationsNotifier.updateConnectionStatus(false);
  }

  void _handleSSEMessage(String line) {
    print('[SSE] Received line: $line');
    if (line.trim().isEmpty || line.startsWith(':')) return;

    try {
      // Parse SSE format: "data: {json}"
      if (line.startsWith('data: ')) {
        final data = line.substring(6).trim();
        if (data == 'ping') {
          print('[SSE] Received ping');
          return;
        }
        if (data.isNotEmpty) {
          print('[SSE] Processing notification data: $data');
          final notificationJson = json.decode(data);

          final parsedData = _parseNotificationData(
            notificationJson['data'],
            notificationJson['type'],
          );

          // Create notification using builder pattern
          final notification = api.Notification(
            (b) => b
              ..id = notificationJson['id'] ?? ''
              ..userId = notificationJson['userId'] ?? ''
              ..type = _parseNotificationType(notificationJson['type'])
              ..message = notificationJson['message'] ?? ''
              ..read = notificationJson['read'] ?? false
              ..createdAt = DateTime.parse(
                notificationJson['createdAt'] ??
                    DateTime.now().toIso8601String(),
              )
              ..updatedAt = DateTime.parse(
                notificationJson['updatedAt'] ??
                    DateTime.now().toIso8601String(),
              )
              ..version = notificationJson['version'] ?? 0
              ..data = parsedData != null
                  ? (api.NotificationDataBuilder()..anyOf = parsedData)
                  : null,
          );

          print(
            '[SSE] Created notification: ${notification.id} - ${notification.type} - ${notification.message} - ${notification.data}',
          );

          // Handle the notification based on its type
          _handleRealtimeUpdate(notification);
        }
      }
    } catch (error) {
      print('[SSE] Error parsing SSE message: $error');
      // Ignore parsing errors for individual messages
    }
  }

  api.NotificationTypeEnum _parseNotificationType(String? typeString) {
    switch (typeString) {
      case 'CHANGE_OF_POSSESSED_GEMS':
        return api.NotificationTypeEnum.CHANGE_OF_POSSESSED_GEMS;
      case 'DIAMOND_UPDATE':
        return api.NotificationTypeEnum.DIAMOND_UPDATE;
      case 'RANKING_UPDATE':
        return api.NotificationTypeEnum.RANKING_UPDATE;
      default:
        return api.NotificationTypeEnum.CHANGE_OF_POSSESSED_GEMS;
    }
  }

  dynamic _parseNotificationData(dynamic dataJson, String? typeString) {
    if (dataJson == null) return null;

    try {
      switch (typeString) {
        case 'DIAMOND_UPDATE':
        case 'CHANGE_OF_POSSESSED_GEMS':
          // Parse DataMessage: { gain: number, newDiamonds: number }
          if (dataJson is Map<String, dynamic>) {
            final gain = dataJson['gain'] as num?;
            final newDiamonds = dataJson['newDiamonds'] as num?;
            if (gain != null && newDiamonds != null) {
              return AnyOf<api.NotificationDataAnyOf, api.NotificationDataAnyOf1>.left(api.NotificationDataAnyOf(
                (b) => b
                  ..gain = gain
                  ..newDiamonds = newDiamonds,
              ));
            }
          }
          break;

        case 'RANKING_UPDATE':
          // Parse UserRankingMessage: { rankings: UserRanking[] }
          if (dataJson is Map<String, dynamic> &&
              dataJson['rankings'] is List) {
            final rankingsJson = dataJson['rankings'] as List;
            final rankings = rankingsJson
                .map((rankingJson) {
                  if (rankingJson is Map<String, dynamic>) {
                    return api.NotificationDataAnyOf1RankingsInner(
                      (b) => b
                        ..firstName = rankingJson['firstName'] ?? ''
                        ..lastName = rankingJson['lastName'] ?? ''
                        ..score = rankingJson['score'] ?? 0
                        ..imageUrl = rankingJson['imageUrl'] ?? '',
                    );
                  }
                  return null;
                })
                .whereType<api.NotificationDataAnyOf1RankingsInner>()
                .toList();

            return AnyOf<api.NotificationDataAnyOf, api.NotificationDataAnyOf1>.right(api.NotificationDataAnyOf1(
              (b) => b
                ..rankings =
                    ListBuilder<api.NotificationDataAnyOf1RankingsInner>(
                      rankings,
                    ),
            ));
          }
          break;
      }
    } catch (error) {
      print('[SSE] Error parsing notification data: $error');
    }

    return null;
  }

  void _handleRealtimeUpdate(api.Notification notification) {
    print(
      '[SSE] Processing realtime notification: ${notification.type} - ${notification.message}',
    );

    // Handle different notification types
    switch (notification.type) {
      case api.NotificationTypeEnum.DIAMOND_UPDATE:
        _handleDiamondUpdate(notification);
        break;
      case api.NotificationTypeEnum.RANKING_UPDATE:
      case api.NotificationTypeEnum.CHANGE_OF_POSSESSED_GEMS:
      default:
        // For other types, just add as notification
        _notificationsNotifier.addRealtimeNotification(notification);
        break;
    }

    print('[SSE] Notification processed');
  }

  void _handleDiamondUpdate(api.Notification notification) {
    print('[SSE] Handling diamond update notification');

    // Try to get new diamond count from the parsed notification data first
    if (notification.data != null &&
        notification.data!.anyOf is api.NotificationDataAnyOf) {
      final dataMessage = notification.data!.anyOf as api.NotificationDataAnyOf;
      final newDiamonds = dataMessage.newDiamonds?.toInt();
      if (newDiamonds != null) {
        print('[SSE] Updating user diamonds to: $newDiamonds from data');
        _userDataNotifier.updateDiamonds(newDiamonds);
      } else {
        print('[SSE] newDiamonds is null in notification data');
      }
    } else {
      // Fallback: Try to extract from message if data parsing failed
      print('[SSE] Data not available, falling back to message parsing');
      final message = notification.message.toLowerCase();
      final diamondRegex = RegExp(r'(\d+)');
      final match = diamondRegex.firstMatch(message);

      if (match != null) {
        final newDiamonds = int.tryParse(match.group(1) ?? '');
        if (newDiamonds != null) {
          print('[SSE] Updating user diamonds to: $newDiamonds from message');
          _userDataNotifier.updateDiamonds(newDiamonds);
        } else {
          print('[SSE] Could not parse diamond count from message: $message');
        }
      } else {
        print('[SSE] No diamond count found in message: $message');
      }
    }

    // Also add the notification to the list
    _notificationsNotifier.addRealtimeNotification(notification);
  }

  void _handleSSEError(Object error) {
    print('[SSE] SSE connection error: $error');

    // Update notifications connection status
    _notificationsNotifier.updateConnectionStatus(false);

    if (_sseSubscription != null) {
      _sseSubscription!.cancel();
      _sseSubscription = null;
    }

    // Only attempt reconnection if we haven't exceeded max attempts
    // and if the error is not a type error (which suggests a programming issue)
    if (_reconnectAttempts < _maxReconnectAttempts &&
        !error.toString().contains('type')) {
      _attemptReconnect();
    } else {
      print(
        '[SSE] Not attempting reconnection due to error type or max attempts reached',
      );
    }
  }

  void _handleSSEDone() {
    print('[SSE] SSE connection closed');

    // Update notifications connection status
    _notificationsNotifier.updateConnectionStatus(false);

    if (_shouldReconnect) {
      _attemptReconnect();
    }
  }

  void _attemptReconnect() {
    if (!_shouldReconnect ||
        _reconnectAttempts >= _maxReconnectAttempts ||
        !_authState.isAuthenticated ||
        _authState.accessToken == null) {
      if (_reconnectAttempts >= _maxReconnectAttempts) {
        print(
          '[SSE] Max reconnection attempts reached ($_maxReconnectAttempts), giving up',
        );
      } else if (!_authState.isAuthenticated) {
        print('[SSE] Not attempting reconnection: User not authenticated');
      } else if (_authState.accessToken == null) {
        print('[SSE] Not attempting reconnection: No access token available');
      }
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(
      milliseconds: (1000 * (1 << (_reconnectAttempts - 1))).clamp(0, 30000),
    );

    print(
      '[SSE] Attempting reconnection in ${delay.inMilliseconds}ms (attempt $_reconnectAttempts/$_maxReconnectAttempts)',
    );

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (_shouldReconnect &&
          _authState.isAuthenticated &&
          _authState.accessToken != null) {
        print('[SSE] Executing reconnection attempt $_reconnectAttempts');
        _connectSSE();
      }
    });
  }

  void dispose() {
    _disconnectSSE();
  }
}
