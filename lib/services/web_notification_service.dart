// Web-only notification service
class WebNotificationService {
  WebNotificationService._();
  static final WebNotificationService instance = WebNotificationService._();

  Future<void> init() async {
    // Web notifications will be handled by conditional imports
  }

  Future<void> sendLocalNotification({
    int id = 1,
    String title = 'Hello!',
    String body = 'This is your notification.',
  }) async {
    // Web notifications will be handled by conditional imports
  }
}
