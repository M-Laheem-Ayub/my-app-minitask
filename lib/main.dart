import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'services/unified_notification_service.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');

    // Initialize notification service with Firebase Messaging
    try {
      await UnifiedNotificationService.instance.init();
      print('Notification service initialized successfully');
    } catch (e) {
      print('Notification service initialization failed: $e');
      // Continue without notification service
    }

    runApp(const MyApp());
  } catch (e) {
    print('App initialization failed: $e');
    // Show error screen
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('App initialization failed: $e'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
