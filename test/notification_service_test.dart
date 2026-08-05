import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_build/screens/settings/app_settings_screen.dart';
import 'package:nexus_build/services/notification_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NotificationService Tests', () {
    test('defaults notificationsEnabled to true', () {
      expect(NotificationService.notificationsEnabled, isTrue);
    });

    testWidgets('AppSettingsScreen renders Notifications toggle tile', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppSettingsScreen(),
        ),
      );

      expect(find.text('Notifications'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });
  });
}
