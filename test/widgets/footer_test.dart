import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/footer.dart';

void main() {
  Widget createTestWidget() {
    return const MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Footer(),
        ),
      ),
    );
  }

  testWidgets('Footer displays all sections', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Check for section headers
    expect(find.text('Opening Hours'), findsOneWidget);
    expect(find.text('Help and Information'), findsOneWidget);
    expect(find.text('Latest Offers'), findsOneWidget);
  });

  testWidgets('Footer displays opening hours content', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('❄️ Winter Break Closure Dates ❄️'), findsOneWidget);
    expect(find.text('Monday - Friday 10am - 4pm'), findsOneWidget);
    expect(find.text('Purchase online 24/7'), findsOneWidget);
  });

  testWidgets('Footer displays help links', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Terms & Conditions of Sale Policy'), findsOneWidget);
  });

  testWidgets('Footer displays newsletter signup', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Email address'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
  });

  testWidgets('Footer displays social icons', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    expect(find.byIcon(Icons.facebook), findsOneWidget);
    expect(find.byIcon(Icons.alternate_email), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
  });

  testWidgets('Footer layout changes on desktop', (WidgetTester tester) async {
    // Set screen size to desktop
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget());

    // On desktop, sections are in a Row, so no Dividers between them
    expect(find.byType(Divider), findsNothing);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('Footer layout changes on mobile', (WidgetTester tester) async {
    // Set screen size to mobile
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget());

    // On mobile, sections are in a Column with Dividers
    expect(find.byType(Divider), findsNWidgets(2));

    addTearDown(tester.view.resetPhysicalSize);
  });
}
