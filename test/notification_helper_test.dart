import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_build/constants/app_colors.dart';
import 'package:nexus_build/utils/notification_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: child,
      ),
    );
  }

  group('NotificationHelper Tests', () {
    testWidgets('showSuccess displays green floating snackbar with check icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => NotificationHelper.showSuccess(context, 'Project saved successfully'),
              child: const Text('Trigger Success'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger Success'));
      await tester.pumpAndSettle();

      expect(find.text('Project saved successfully'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, equals(AppColors.accentGreen));
      expect(snackBar.behavior, equals(SnackBarBehavior.floating));
      expect(snackBar.duration, equals(const Duration(seconds: 3)));
    });

    testWidgets('showError displays red floating snackbar with error icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => NotificationHelper.showError(context, 'Invalid credentials'),
              child: const Text('Trigger Error'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger Error'));
      await tester.pumpAndSettle();

      expect(find.text('Invalid credentials'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, equals(AppColors.error));
      expect(snackBar.behavior, equals(SnackBarBehavior.floating));
    });

    testWidgets('showInfo displays navy floating snackbar with info icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestableWidget(
          Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => NotificationHelper.showInfo(context, 'Estimate ready'),
              child: const Text('Trigger Info'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger Info'));
      await tester.pumpAndSettle();

      expect(find.text('Estimate ready'), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);

      final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
      expect(snackBar.backgroundColor, equals(AppColors.primary));
      expect(snackBar.behavior, equals(SnackBarBehavior.floating));
    });
  });
}
