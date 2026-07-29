import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naga_cakes/core/theme/app_colors.dart';

import 'package:naga_cakes/shared_widgets/app_button.dart';

void main() {
  testWidgets('AppButton renders label and triggers onPressed callback', (WidgetTester tester) async {
    bool pressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [AppColors.light]),
        home: Scaffold(
          body: AppButton(
            label: 'TEST BUTTON',
            onPressed: () {
              pressed = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('TEST BUTTON'), findsOneWidget);

    await tester.tap(find.text('TEST BUTTON'));
    expect(pressed, true);
  });
}
