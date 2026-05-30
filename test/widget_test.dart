import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('placeholder', (WidgetTester tester) async {
    // Nexus Build uses Hive which requires a real device/emulator to initialise.
    // Add integration tests in integration_test/ when running on a device.
    expect(true, isTrue);
  });
}
