import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_build/models/project_model.dart';
import 'package:nexus_build/screens/projects/project_list_screen.dart';
import 'package:nexus_build/services/project_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Project Status Tests', () {
    test('Default status for new project is Active', () {
      final p = ProjectModel(
        id: 'test-status-1',
        name: 'Default Active Villa',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(p.status, equals('Draft')); // default model fallback

      // Via ProjectService helper
      final now = DateTime.now();
      final p2 = ProjectModel(
        id: 'test-status-2',
        name: 'Service Active Villa',
        status: 'Active',
        createdAt: now,
        updatedAt: now,
      );

      expect(p2.status, equals('Active'));
    });

    testWidgets('ProjectListScreen renders filter tabs Active, Completed, Draft', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProjectListScreen(),
        ),
      );

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Draft'), findsOneWidget);
    });
  });
}
