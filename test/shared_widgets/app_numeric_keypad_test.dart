import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naga_cakes/core/theme/app_colors.dart';
import 'package:naga_cakes/shared_widgets/app_numeric_keypad.dart';

void main() {
  testWidgets('AppNumericKeypad emits key taps correctly', (WidgetTester tester) async {
    String pressedVal = '';
    bool cleared = false;
    bool deleted = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [AppColors.light]),
        home: Scaffold(
          body: AppNumericKeypad(
            onKeyPress: (val) {
              pressedVal += val;
            },
            onClear: () {
              cleared = true;
            },
            onDelete: () {
              deleted = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('5'), findsOneWidget);
    await tester.tap(find.text('5'));
    await tester.tap(find.text('0'));

    expect(pressedVal, '50');

    await tester.tap(find.byIcon(Icons.clear_rounded));
    expect(cleared, true);

    await tester.tap(find.byIcon(Icons.backspace_outlined));
    expect(deleted, true);
  });
}
