import 'dart:html' as html;

class WebNotificationService {
  WebNotificationService._();
  static final WebNotificationService instance = WebNotificationService._();

  Future<void> init() async {
    // Request notification permission on web
    if (html.Notification.supported) {
      await html.Notification.requestPermission();
    }
  }

  Future<void> sendLocalNotification({
    int id = 1,
    String title = 'Hello!',
    String body = 'This is your notification.',
  }) async {
    if (html.Notification.supported &&
        html.Notification.permission == 'granted') {
      html.Notification(
        title,
        body: body,
        icon: '/assets/icons/icon.png', // Use your app icon
        tag: 'my_app_notification_$id',
      );
    }
  }
}
