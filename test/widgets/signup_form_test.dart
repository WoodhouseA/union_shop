import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/signup_form.dart';

void main() {
  Widget createTestWidget({VoidCallback? onToggle}) {
    return MaterialApp(
      home: Scaffold(
        body: SignupForm(
          onToggle: onToggle ?? () {},
        ),
      ),
    );
  }

  testWidgets('SignupForm displays all fields', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // There are two "Sign Up" texts: one in the title and one in the button
    expect(find.text('Sign Up'), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Already have an account? Login'), findsOneWidget);
  });
}
