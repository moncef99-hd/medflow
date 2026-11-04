import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medflow/shared/widgets/gradient_button.dart';

void main() {
  testWidgets('GradientButton shows its label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GradientButton(label: 'Continuer', onPressed: () {}),
        ),
      ),
    );

    expect(find.text('Continuer'), findsOneWidget);
  });
}