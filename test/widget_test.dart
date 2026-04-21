// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:moblie_app/main.dart';
import 'package:moblie_app/widgets/brand_widgets.dart';

void main() {
  testWidgets('App builds and shows splash branding', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const DishGenieApp());

    // First frame should be the splash screen.
    expect(find.byType(DishGenieWordmark), findsOneWidget);
    expect(find.text('Khmer flavors, made simple'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Splash schedules a delayed navigation; advance time so no timer remains.
    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pumpAndSettle();
  });
}
