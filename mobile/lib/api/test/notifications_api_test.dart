import 'package:test/test.dart';
import 'package:openapi/openapi.dart';


/// tests for NotificationsApi
void main() {
  final instance = Openapi().getNotificationsApi();

  group(NotificationsApi, () {
    //Future notificationsControllerDeleteNotification(String id) async
    test('test notificationsControllerDeleteNotification', () async {
      // TODO
    });

    //Future<BuiltList<Notification>> notificationsControllerGetUserNotifications() async
    test('test notificationsControllerGetUserNotifications', () async {
      // TODO
    });

    //Future notificationsControllerMarkNotificationAsRead(String notificationId) async
    test('test notificationsControllerMarkNotificationAsRead', () async {
      // TODO
    });

    //Future notificationsControllerSse() async
    test('test notificationsControllerSse', () async {
      // TODO
    });

  });
}
