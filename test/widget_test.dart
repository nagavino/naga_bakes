import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naga_cakes/core/theme/app_colors.dart';
import 'package:naga_cakes/shared_widgets/app_card.dart';

void main() {
  testWidgets('AppCard renders child and responds to tap', (WidgetTester tester) async {
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: const [AppColors.light]),
        home: Scaffold(
          body: AppCard(
            onTap: () => tapped = true,
            child: const Text('CARD CONTENT'),
          ),
        ),
      ),
    );

    expect(find.text('CARD CONTENT'), findsOneWidget);
    await tester.tap(find.text('CARD CONTENT'));
    expect(tapped, true);
  });
}
