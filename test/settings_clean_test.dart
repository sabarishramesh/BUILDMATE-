import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_build/screens/settings/app_settings_screen.dart';
import 'package:nexus_build/screens/settings/offline_storage_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppSettingsScreen Tests', () {
    testWidgets('hides Upgrade option while preserving valid options and Notifications toggle', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppSettingsScreen(),
        ),
      );

      expect(find.text('Units & Measurements'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Offline Storage'), findsOneWidget);
      expect(find.text('Construction Glossary'), findsOneWidget);
      expect(find.text('Help & FAQ'), findsOneWidget);

      expect(find.text('Upgrade to Pro'), findsNothing);
    });
  });

  group('OfflineStorageScreen Tests', () {
    testWidgets('displays Clear Temporary Files button and explicit project safety confirmation', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: OfflineStorageScreen(),
        ),
      );

      final clearBtn = find.text('Clear Temporary Files');
      expect(clearBtn, findsOneWidget);

      await tester.ensureVisible(clearBtn);
      await tester.pumpAndSettle();

      await tester.tap(clearBtn);
      await tester.pumpAndSettle();

      expect(find.text('Clear Temporary Files?'), findsOneWidget);
      expect(
        find.textContaining('Your saved projects, material rates, and user accounts will remain completely safe and untouched'),
        findsOneWidget,
      );
    });
  });
}
