import 'package:flutter/foundation.dart';
import 'notification_service.dart';
import 'web_notification_service.dart'
    if (dart.library.html) 'web_notification_service_web.dart';

class UnifiedNotificationService {
  UnifiedNotificationService._();
  static final UnifiedNotificationService instance =
      UnifiedNotificationService._();

  Future<void> init() async {
    if (kIsWeb) {
      await WebNotificationService.instance.init();
    } else {
      // Initialize for Android and iOS with Firebase Messaging
      await NotificationService.instance.init();
    }
  }

  Future<void> sendLocalNotification({
    int id = 1,
    String title = 'Hello!',
    String body = 'This is your notification.',
  }) async {
    print(
      'UnifiedNotificationService: Sending notification - Platform: ${kIsWeb ? "Web" : defaultTargetPlatform}',
    );

    if (kIsWeb) {
      await WebNotificationService.instance.sendLocalNotification(
        id: id,
        title: title,
        body: body,
      );
    } else {
      // Send notifications on Android and iOS using Firebase Messaging approach
      await NotificationService.instance.sendLocalNotification(
        id: id,
        title: title,
        body: body,
      );
    }
  }
}
