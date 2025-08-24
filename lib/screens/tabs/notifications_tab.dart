import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/unified_notification_service.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Notifications Tab',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 100),
            Center(
              child: GestureDetector(
                onTap: () async {
                  setState(() => _isTapped = true);

                  try {
                    final user = FirebaseAuth.instance.currentUser;
                    final displayName = (user?.displayName ?? '').trim();
                    final emailName = ((user?.email ?? '').contains('@')
                        ? (user?.email ?? '').split('@').first
                        : (user?.email ?? ''));
                    final name = displayName.isNotEmpty
                        ? displayName
                        : (emailName.isNotEmpty ? emailName : 'there');

                    print('Sending notification to: $name');

                    await UnifiedNotificationService.instance
                        .sendLocalNotification(
                          title: 'Hi, $name',
                          body: 'You have a new notification.',
                        );

                    print('Notification sent successfully');
                  } catch (e) {
                    print('Error sending notification: $e');
                    // Show a snackbar to indicate error
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to send notification: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }

                  // Reset color after 1 second
                  await Future.delayed(const Duration(milliseconds: 200));
                  if (mounted) setState(() => _isTapped = false);
                },
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: _isTapped ? const Color(0xfff3617b) : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: _isTapped
                      ? Icon(Icons.notifications, size: 60, color: Colors.white)
                      : ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF3361c3), Color(0xffbf4dd6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Icon(
                            Icons.notifications,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Tap the bell to send yourself a notification'),
          ],
        ),
      ),
    );
  }
}
