import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/auth_page.dart';

void main() {
  testWidgets('AuthPage toggles between Login and Signup', (WidgetTester tester) async {
    // Build the AuthPage widget wrapped in a Scaffold
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: AuthPage())));

    // Verify that the Login page is shown initially
    expect(find.text('Login'), findsWidgets); // Finds title and button
    expect(find.text('Don\'t have an account? Sign up'), findsOneWidget);
    expect(find.text('Sign Up'), findsNothing);

    // Tap the toggle button to switch to Signup page
    await tester.tap(find.text('Don\'t have an account? Sign up'));
    await tester.pump(); // Rebuild the widget

    // Verify that the Signup page is shown
    expect(find.text('Sign Up'), findsWidgets); // Finds title and button
    expect(find.text('Already have an account? Login'), findsOneWidget);
    expect(find.text('Login'), findsNothing);

    // Tap the toggle button to switch back to Login page
    await tester.tap(find.text('Already have an account? Login'));
    await tester.pump(); // Rebuild the widget

    // Verify that the Login page is shown again
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Don\'t have an account? Sign up'), findsOneWidget);
  });
}
