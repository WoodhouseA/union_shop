import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/views/auth_page.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- Mock AuthService ---

class MockAuthService extends ChangeNotifier implements AuthService {
  @override
  User? get currentUser => null;

  @override
  Stream<User?> get authStateChanges => Stream.value(null);

  @override
  Future<User?> signIn(String email, String password) async {
    return null;
  }

  @override
  Future<User?> signUp(String email, String password) async {
    return null;
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  testWidgets('AuthPage toggles between Login and Signup', (WidgetTester tester) async {
    // Build the AuthPage widget wrapped in a Scaffold and Provider
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthService>(
        create: (_) => MockAuthService(),
        child: const MaterialApp(
          home: Scaffold(body: AuthPage()),
        ),
      ),
    );

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
