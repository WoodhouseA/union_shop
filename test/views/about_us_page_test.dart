import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/about_us_page.dart';

void main() {
  testWidgets('AboutUsPage displays correct content', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutUsPage()));

    // Verify title
    expect(find.text('Welcome to the Union Shop!'), findsOneWidget);

    // Verify body text parts
    expect(find.textContaining('We’re dedicated to giving you the very best University branded products'), findsOneWidget);
    expect(find.textContaining('All online purchases are available for delivery or instore collection!'), findsOneWidget);
    expect(find.textContaining('hello@upsu.net'), findsOneWidget);
    
    // Verify footer
    expect(find.text('Happy shopping!'), findsOneWidget);
    expect(find.text('The Union Shop & Reception Team'), findsOneWidget);

    // Verify scroll view
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
