import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart' as api;
import 'package:mobile/providers/api_providers.dart';
import 'package:dio/dio.dart';

// State class for notifications
class NotificationsState {
  final List<NotificationItem> notifications;
  final bool isLoading;
  final String? error;
  final bool isConnected;
  final int unreadCount;

  const NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
    this.error,
    this.isConnected = false,
    this.unreadCount = 0,
  });

  NotificationsState copyWith({
    List<NotificationItem>? notifications,
    bool? isLoading,
    String? error,
    bool? isConnected,
    int? unreadCount,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isConnected: isConnected ?? this.isConnected,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

// Wrapper class for notifications with real-time flag
class NotificationItem {
  final api.Notification notification;
  final bool isRealTime;

  const NotificationItem({required this.notification, this.isRealTime = false});

  NotificationItem copyWith({
    api.Notification? notification,
    bool? isRealTime,
  }) {
    return NotificationItem(
      notification: notification ?? this.notification,
      isRealTime: isRealTime ?? this.isRealTime,
    );
  }
}

// Provider for notifications state
final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
      final api = ref.watch(notificationsApiProvider);
      final dio = ref.watch(dioProvider);
      return NotificationsNotifier(api, dio);
    });

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final api.NotificationsApi _api;
  final Dio _dio;

  StreamSubscription<String>? _sseSubscription;
  bool _shouldReconnect = true;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 10;
  Timer? _reconnectTimer;

  NotificationsNotifier(this._api, this._dio)
    : super(const NotificationsState()) {
    loadNotifications();
  }

  @override
  void dispose() {
    _disconnectSSE();
    super.dispose();
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _api.notificationsControllerGetUserNotifications();
      if (response.statusCode == 200 && response.data != null) {
        final notificationItems = response.data!
            .map((n) => NotificationItem(notification: n, isRealTime: false))
            .toList();

        final unreadCount = notificationItems
            .where((item) => !item.notification.read)
            .length;

        state = state.copyWith(
          notifications: notificationItems,
          isLoading: false,
          unreadCount: unreadCount,
        );

        // Start SSE connection after loading initial notifications
        _connectSSE();
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load notifications',
        );
      }
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error.toString());
    }
  }

  void _connectSSE() {
    if (_sseSubscription != null) return;

    _shouldReconnect = true;
    _reconnectAttempts = 0;

    try {
      // Create SSE stream using Dio
      final request = RequestOptions(
        path: '/notifications/sse',
        method: 'GET',
        responseType: ResponseType.stream,
      );

      _dio
          .fetch(request)
          .then((response) {
            if (response.data is ResponseBody) {
              final stream = response.data.stream;
              _sseSubscription = stream
                  .transform(utf8.decoder)
                  .transform(LineSplitter())
                  .listen(
                    _handleSSEMessage,
                    onError: _handleSSEError,
                    onDone: _handleSSEDone,
                    cancelOnError: false,
                  );

              state = state.copyWith(isConnected: true);
            }
          })
          .catchError((error) {
            _handleSSEError(error);
          });
    } catch (error) {
      _handleSSEError(error);
    }
  }

  void _disconnectSSE() {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();

    if (_sseSubscription != null) {
      _sseSubscription!.cancel();
      _sseSubscription = null;
    }

    state = state.copyWith(isConnected: false);
  }

  void _handleSSEMessage(String line) {
    if (line.trim().isEmpty || line.startsWith(':')) return;

    try {
      // Parse SSE format: "data: {json}"
      if (line.startsWith('data: ')) {
        final data = line.substring(6).trim();
        if (data != 'ping' && data.isNotEmpty) {
          // For now, create a simple notification from the data
          // In a real implementation, you'd use proper deserialization
          final notificationJson = json.decode(data);

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
              ..data = null,
          ); // TODO: Handle notification data parsing

          // Handle different notification types
          _handleNotification(notification);

          // Add to notifications list if not a ranking update
          if (notification.type != api.NotificationTypeEnum.RANKING_UPDATE) {
            final newItem = NotificationItem(
              notification: notification,
              isRealTime: true,
            );

            final updatedNotifications = [newItem, ...state.notifications];
            final unreadCount = updatedNotifications
                .where((item) => !item.notification.read)
                .length;

            state = state.copyWith(
              notifications: updatedNotifications,
              unreadCount: unreadCount,
            );
          }
        }
      }
    } catch (error) {
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

  void _handleSSEError(Object error) {
    state = state.copyWith(isConnected: false);

    if (_sseSubscription != null) {
      _sseSubscription!.cancel();
      _sseSubscription = null;
    }

    _attemptReconnect();
  }

  void _handleSSEDone() {
    state = state.copyWith(isConnected: false);

    if (_shouldReconnect) {
      _attemptReconnect();
    }
  }

  void _attemptReconnect() {
    if (!_shouldReconnect || _reconnectAttempts >= _maxReconnectAttempts) {
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(
      milliseconds: (1000 * (1 << (_reconnectAttempts - 1))).clamp(0, 30000),
    );

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      if (_shouldReconnect) {
        _connectSSE();
      }
    });
  }

  void _handleNotification(api.Notification notification) {
    // Handle different notification types
    // This could be extended to update other state like diamonds, rankings, etc.
    switch (notification.type) {
      case api.NotificationTypeEnum.CHANGE_OF_POSSESSED_GEMS:
        // Could update user diamonds here
        break;
      case api.NotificationTypeEnum.DIAMOND_UPDATE:
        // Could update gained diamonds here
        break;
      case api.NotificationTypeEnum.RANKING_UPDATE:
        // Could update rankings here
        break;
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _api.notificationsControllerMarkNotificationAsRead(
        notificationId: notificationId,
      );

      // Update local state
      final updatedNotifications = state.notifications.map((item) {
        if (item.notification.id == notificationId) {
          return item.copyWith(
            notification: item.notification.rebuild((b) => b.read = true),
          );
        }
        return item;
      }).toList();

      final unreadCount = updatedNotifications
          .where((item) => !item.notification.read)
          .length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      );
    } catch (error) {
      // For now, just ignore errors on mark as read
      // Could add error handling later
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _api.notificationsControllerDeleteNotification(id: notificationId);

      // Remove from local state
      final updatedNotifications = state.notifications
          .where((item) => item.notification.id != notificationId)
          .toList();

      final unreadCount = updatedNotifications
          .where((item) => !item.notification.read)
          .length;

      state = state.copyWith(
        notifications: updatedNotifications,
        unreadCount: unreadCount,
      );
    } catch (error) {
      // For now, just ignore errors on delete
      // Could add error handling later
    }
  }
}
