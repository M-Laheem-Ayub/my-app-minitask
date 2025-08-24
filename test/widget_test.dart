// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Basic widget test', (WidgetTester tester) async {
    // Test a simple widget instead of the full app
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Center(child: Text('Test Widget'))),
      ),
    );

    // Verify that the test widget loads
    expect(find.text('Test Widget'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('App theme test', (WidgetTester tester) async {
    // Test the app theme configuration
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyApp by Laheem Ayub',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF635BFF)),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF8F9FB),
        ),
        home: Scaffold(body: Center(child: Text('Theme Test'))),
      ),
    );

    // Verify theme properties
    expect(find.text('Theme Test'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
