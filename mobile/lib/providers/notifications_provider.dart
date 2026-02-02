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

  NotificationsNotifier(this._api) : super(const NotificationsState()) {
    print('[NOTIFICATIONS] NotificationsNotifier initialized');
    // Reset loading state in case it was stuck from previous app session
    _resetLoadingStateIfNeeded();
  }

  void _resetLoadingStateIfNeeded() {
    // If the state shows loading but we just initialized, reset it
    if (state.isLoading) {
      print(
        '[NOTIFICATIONS] Resetting stuck loading state from previous session',
      );
      state = state.copyWith(
        isLoading: false,
        error: 'Loading was interrupted. Please try again.',
      );
    } else {
      print('[NOTIFICATIONS] Loading state is clean');
    }
  }

  // Method to manually reset loading state if needed
  void resetLoadingState() {
    if (state.isLoading) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> loadNotifications() async {
    // If already loading, don't start another request
    if (state.isLoading) {
      print('[NOTIFICATIONS] Already loading, skipping duplicate request');
      return;
    }

    print('[NOTIFICATIONS] Starting to load notifications...');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _api
          .notificationsControllerGetUserNotifications()
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request timed out after 10 seconds');
            },
          );

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
        print(
          '[NOTIFICATIONS] Successfully loaded ${notificationItems.length} notifications',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Failed to load notifications: HTTP ${response.statusCode}',
        );
        print(
          '[NOTIFICATIONS] Failed to load notifications: HTTP ${response.statusCode}',
        );
      }
    } catch (error) {
      print('[NOTIFICATIONS] Error loading notifications: $error');
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load notifications: ${error.toString()}',
      );
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
          .where((item) => !item.isRead)
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

  // Clear all notifications (used on logout)
  void clearAllNotifications() {
    state = const NotificationsState();
  }
}
