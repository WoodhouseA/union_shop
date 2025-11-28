import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/print_shack_about_page.dart';

void main() {
  testWidgets('PrintShackAboutPage renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PrintShackAboutPage(),
          ),
        ),
      ),
    );

    // Verify main title
    expect(find.text('The Union Print Shack'), findsOneWidget);

    // Verify section titles
    expect(find.text('Make It Yours at The Union Print Shack'), findsOneWidget);
    expect(find.text('Uni Gear or Your Gear - We’ll Personalise It'), findsOneWidget);
    expect(find.text('Simple Pricing, No Surprises'), findsOneWidget);
    expect(find.text('Personalisation Terms & Conditions'), findsOneWidget);
    expect(find.text('Ready to Make It Yours?'), findsOneWidget);

    // Verify some content text (checking for substrings or full text)
    expect(find.textContaining('Want to add a personal touch?'), findsOneWidget);
    expect(find.textContaining('Customising your gear won’t break the bank'), findsOneWidget);
  });
}
