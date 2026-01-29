import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    print('[NOTIFICATION] Initializing notification service...');

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap if needed
        print('Notification tapped: ${response.payload}');
      },
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'kickstream_channel',
      'KickStream Notifications',
      description: 'Notifications for KickStream app',
      importance: Importance.high,
      playSound: true,
      showBadge: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // Request permissions after initialization
    await _requestPermissions();

    print('[NOTIFICATION] Notification service initialized successfully');
  }

  Future<void> _requestPermissions() async {
    print('[NOTIFICATION] Requesting notification permissions...');

    // Request permissions for Android 13+ and iOS
    final androidResult = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    final iosResult = await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    print(
      '[NOTIFICATION] Permission requests completed - Android: $androidResult, iOS: $iosResult',
    );
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    print('[NOTIFICATION] Showing notification: $title - $body');

    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'kickstream_channel',
        'KickStream Notifications',
        channelDescription: 'Notifications for KickStream app',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // Unique ID
      title,
      body,
      notificationDetails,
      payload: payload,
    );

    print('[NOTIFICATION] Notification sent successfully');
  }

  Future<void> showDiamondUpdateNotification(int newDiamonds) async {
    await showNotification(
      title: '💎 Diamonds Updated!',
      body: 'You now have $newDiamonds diamonds!',
    );
  }

  Future<void> showRankingUpdateNotification() async {
    await showNotification(
      title: '🏆 Rankings Updated!',
      body: 'The leaderboard has been updated with the latest scores.',
    );
  }

  Future<void> showGenericNotification(String title, String message) async {
    await showNotification(title: title, body: message);
  }

  // Test method to verify notifications work
  Future<void> showTestNotification() async {
    await showNotification(
      title: '🧪 Test Notification',
      body: 'This is a test notification to verify the system works!',
    );
  }
}
