import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/openapi.dart' as api;
import 'package:mobile/providers/api_providers.dart';

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

// Wrapper class for notifications with real-time flag and local read state
class NotificationItem {
  final api.Notification notification;
  final bool isRealTime;
  final bool isRead;

  NotificationItem({
    required this.notification,
    this.isRealTime = false,
    bool? isRead,
  }) : isRead = isRead ?? notification.read;

  NotificationItem copyWith({
    api.Notification? notification,
    bool? isRealTime,
    bool? isRead,
  }) {
    return NotificationItem(
      notification: notification ?? this.notification,
      isRealTime: isRealTime ?? this.isRealTime,
      isRead: isRead ?? this.isRead,
    );
  }
}

// Provider for notifications state
final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
      final api = ref.watch(notificationsApiProvider);
      return NotificationsNotifier(api);
    });

class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final api.NotificationsApi _api;

  NotificationsNotifier(this._api) : super(const NotificationsState());

  Future<void> loadNotifications() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _api.notificationsControllerGetUserNotifications();
      if (response.statusCode == 200 && response.data != null) {
        final notificationItems = response.data!
            .map((n) => NotificationItem(notification: n, isRealTime: false))
            .toList();

        final unreadCount = notificationItems
            .where((item) => !item.isRead)
            .length;

        state = state.copyWith(
          notifications: notificationItems,
          isLoading: false,
          unreadCount: unreadCount,
        );
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

  void updateConnectionStatus(bool isConnected) {
    state = state.copyWith(isConnected: isConnected);
  }

  void addRealtimeNotification(api.Notification notification) {
    final newItem = NotificationItem(
      notification: notification,
      isRealTime: true,
    );

    final updatedNotifications = [newItem, ...state.notifications];
    final unreadCount = updatedNotifications
        .where((item) => !item.isRead)
        .length;

    state = state.copyWith(
      notifications: updatedNotifications,
      unreadCount: unreadCount,
    );
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _api.notificationsControllerMarkNotificationAsRead(
        notificationId: notificationId,
      );

      // Update local state
      final updatedNotifications = state.notifications.map((item) {
        if (item.notification.id == notificationId) {
          return item.copyWith(isRead: true);
        }
        return item;
      }).toList();

      final unreadCount = updatedNotifications
          .where((item) => !item.isRead)
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
