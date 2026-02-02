import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/providers/rankings_provider.dart';
import 'package:openapi/openapi.dart' as api;
import 'package:mobile/providers/api_providers.dart';
import 'package:mobile/providers/notifications_provider.dart';
import 'package:dio/dio.dart';
import 'package:built_collection/built_collection.dart';
import 'package:mobile/models/custom_notification_models.dart';
import 'package:mobile/services/notification_service.dart';

// ignore_for_file: unchecked_use_of_nullable_value, instantiate_abstract_class, undefined_method

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
  late final RankingsNotifier _rankingsNotifier;
  late final GainedDiamondsNotifier _gainedDiamondsNotifier;
  final NotificationService _notificationService = NotificationService();

  StreamSubscription<String>? _sseSubscription;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;
  Timer? _reconnectTimer;

  // Store custom data for easier access
  final Map<String, NotificationDataUnion> _customDataCache = {};

  RealtimeUpdatesService(this._dio, this._ref, this._authState) {
    // Store reference to notifier to avoid Riverpod ref issues in async callbacks
    _notificationsNotifier = _ref.read(notificationsProvider.notifier);
    _userDataNotifier = _ref.read(userDataProvider.notifier);
    _rankingsNotifier = _ref.read(rankingsProvider.notifier);
    _gainedDiamondsNotifier = _ref.read(gainedDiamondsProvider.notifier);
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

  // Public method to manually reconnect SSE
  void reconnectSSE() {
    print('[SSE] Manual reconnection requested');
    _disconnectSSE();
    _reconnectAttempts = 0; // Reset reconnection attempts
    _connectSSE();
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

          // Simplified parsing using custom models for internal logic
          final customData = _parseNotificationDataSimple(
            notificationJson['data'],
            notificationJson['type'],
          );

          print(
            '[SSE] Parsed custom data: $customData for notification type: ${notificationJson['type']}',
          );

          // Create notification using builder pattern
          final notification = api.Notification(
            (b) => b
              ..id = (notificationJson['id'] as String?) ?? ''
              ..userId = (notificationJson['userId'] as String?) ?? ''
              ..type = _parseNotificationType(
                notificationJson['type'] as String?,
              )
              ..message = (notificationJson['message'] as String?) ?? ''
              ..read = (notificationJson['read'] as bool?) ?? false
              ..createdAt = DateTime.parse(
                (notificationJson['createdAt'] as String?) ??
                    DateTime.now().toIso8601String(),
              )
              ..updatedAt = DateTime.parse(
                (notificationJson['updatedAt'] as String?) ??
                    DateTime.now().toIso8601String(),
              )
              ..version = ((notificationJson['version'] as num?)?.toInt()) ?? 0,
          );

          // Store custom data for easier access in handlers
          _storeCustomDataForNotification(notification, customData);

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

  NotificationDataUnion? _parseNotificationDataSimple(
    dynamic dataJson,
    String? typeString,
  ) {
    if (dataJson == null || dataJson is! Map<String, dynamic>) return null;
    print(
      '[SSE] Parsing notification data for type: $typeString with data: $dataJson',
    );
    try {
      switch (typeString) {
        case 'CHANGE_OF_POSSESSED_GEMS':
        case 'DIAMOND_UPDATE':
          return NotificationDataUnion(
            (b) => b
              ..gain = _safeParseNum(dataJson['gain'])
              ..newDiamonds = _safeParseNum(dataJson['newDiamonds']),
          );

        case 'RANKING_UPDATE':
          final rankingsData = dataJson['rankings'] as List<dynamic>?;
          if (rankingsData != null) {
            final rankings = rankingsData
                .map(
                  (item) => RankingEntry(
                    (b) => b
                      ..firstName = item['firstName'] as String?
                      ..lastName = item['lastName'] as String?
                      ..score = _safeParseNum(item['score'])
                      ..imageUrl = item['imageUrl'] as String?,
                  ),
                )
                .toList();

            return NotificationDataUnion(
              (b) => b.rankings = ListBuilder<RankingEntry>(rankings),
            );
          } else {
            return NotificationDataUnion((b) => b.rankings = null);
          }

        default:
          print('[SSE] Unknown notification type: $typeString');
          return null;
      }
    } catch (error) {
      print('[SSE] Error parsing notification data: $error');
      return null;
    }
  }

  // Helper method to safely parse numbers from JSON (handles both strings and numbers)
  num? _safeParseNum(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    if (value is String) {
      return num.tryParse(value);
    }
    return null;
  }

  void _storeCustomDataForNotification(
    api.Notification notification,
    NotificationDataUnion? customData,
  ) {
    if (customData != null) {
      _customDataCache[notification.id] = customData;
    }
  }

  NotificationDataUnion? _getCustomDataForNotification(
    api.Notification notification,
  ) {
    return _customDataCache[notification.id];
  }

  void _handleRealtimeUpdate(api.Notification notification) {
    final customData = _getCustomDataForNotification(notification);
    print(
      '[SSE] Processing realtime notification: ${notification.type} - ${notification.message} - ${customData.toString()}',
    );

    // Handle different notification types
    switch (notification.type) {
      case api.NotificationTypeEnum.RANKING_UPDATE:
        _handleRankingUpdate(notification);
        break;
      case api.NotificationTypeEnum.DIAMOND_UPDATE:
        _handleDiamondUpdate(notification);
        break;
      case api.NotificationTypeEnum.CHANGE_OF_POSSESSED_GEMS:
        _handleChangeOfPossessedGems(notification);
        break;
      default:
        // For other types, just add as notification
        _notificationsNotifier.addRealtimeNotification(notification);
        break;
    }

    print('[SSE] Notification processed');
  }

  void _handleRankingUpdate(api.Notification notification) {
    // Get the custom data from cache
    final customData = _getCustomDataForNotification(notification);

    print(
      '[SSE] Handling ranking update notification with custom data: $customData',
    );

    // Update the internal rankings table with the rankings from custom data
    if (customData != null && customData.rankings != null) {
      print(
        '[SSE] Updating internal rankings table with ${customData.rankings!.length} entries',
      );
      _rankingsNotifier.updateRankings(customData.rankings!);

      // Show system notification
      //_notificationService.showRankingUpdateNotification();
    } else {
      print('[SSE] No rankings data available in custom data');
    }
  }

  void _handleDiamondUpdate(api.Notification notification) {
    // Get the custom data from cache
    final customData = _getCustomDataForNotification(notification);

    print(
      '[SSE] Handling diamond update notification with custom data: $customData',
    );

    // Try to get new diamond count from the cached custom data
    if (customData != null &&
        (customData.gain != null || customData.newDiamonds != null)) {
      final newDiamonds = customData.gain?.toInt();
      if (newDiamonds != null) {
        print(
          '[SSE] Updating user gained diamonds to: $newDiamonds from custom data',
        );
        _gainedDiamondsNotifier.updateGainedDiamonds(newDiamonds);

        // Show system notification
        _notificationService.showGenericNotification(
          '💎 Diamonds Earned!',
          'You earned $newDiamonds diamonds!',
        );
      } else {
        print('[SSE] newDiamonds is null in custom data');
      }
    } else {
      // Fallback: Try to extract from message if data parsing failed
      print('[SSE] Custom data not available, falling back to message parsing');
      final message = notification.message.toLowerCase();
      final diamondRegex = RegExp(r'(\d+)');
      final match = diamondRegex.firstMatch(message);

      if (match != null) {
        final newDiamonds = int.tryParse(match.group(1) ?? '');
        if (newDiamonds != null) {
          print('[SSE] Updating user diamonds to: $newDiamonds from message');
          _userDataNotifier.updateDiamonds(newDiamonds);

          // Show system notification
          _notificationService.showGenericNotification(
            '💎 Diamonds Updated!',
            'You now have $newDiamonds diamonds!',
          );
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

  void _handleChangeOfPossessedGems(api.Notification notification) {
    // Get the custom data from cache
    final customData = _getCustomDataForNotification(notification);
    print(
      '[SSE] Handling change of possessed gems notification with custom data: $customData',
    );

    // Try to get new diamond count from the cached custom data
    if (customData != null &&
        (customData.gain != null || customData.newDiamonds != null)) {
      final newDiamonds = customData.newDiamonds?.toInt();
      if (newDiamonds != null) {
        print('[SSE] Updating user diamonds to: $newDiamonds from custom data');
        _userDataNotifier.updateDiamonds(newDiamonds);

        // Show system notification
        _notificationService.showGenericNotification(
          '💎 Diamonds Updated!',
          'You now have $newDiamonds diamonds!',
        );
      } else {
        print('[SSE] newDiamonds is null in custom data');
      }
    } else {
      // Fallback: Try to extract from message if data parsing failed
      print('[SSE] Custom data not available, falling back to message parsing');
      final message = notification.message.toLowerCase();
      final diamondRegex = RegExp(r'(\d+)');
      final match = diamondRegex.firstMatch(message);

      if (match != null) {
        final newDiamonds = int.tryParse(match.group(1) ?? '');
        if (newDiamonds != null) {
          print('[SSE] Updating user diamonds to: $newDiamonds from message');
          _userDataNotifier.updateDiamonds(newDiamonds);

          // Show system notification
          _notificationService.showGenericNotification(
            '💎 Diamonds Updated!',
            'You now have $newDiamonds diamonds!',
          );
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
