import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/widgets/login_form.dart';

void main() {
  Widget createTestWidget({VoidCallback? onToggle}) {
    return MaterialApp(
      home: Scaffold(
        body: LoginForm(
          onToggle: onToggle ?? () {},
        ),
      ),
    );
  }

  testWidgets('LoginForm displays all fields', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // There are two "Login" texts: one in the title and one in the button
    expect(find.text('Login'), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Don\'t have an account? Sign up'), findsOneWidget);
  });
}
