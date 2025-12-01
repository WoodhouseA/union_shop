import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/widgets/login_form.dart';
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
  Widget createTestWidget({VoidCallback? onToggle}) {
    return ChangeNotifierProvider<AuthService>(
      create: (_) => MockAuthService(),
      child: MaterialApp(
        home: Scaffold(
          body: LoginForm(
            onToggle: onToggle ?? () {},
          ),
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

  testWidgets('LoginForm validates empty fields', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    // Tap login without entering data
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  testWidgets('LoginForm accepts valid input', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget());

    await tester.enterText(find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('Please enter your email'), findsNothing);
    expect(find.text('Please enter your password'), findsNothing);
  });

  testWidgets('Toggle button triggers callback', (WidgetTester tester) async {
    bool toggled = false;
    await tester.pumpWidget(createTestWidget(onToggle: () {
      toggled = true;
    }));

    await tester.tap(find.text('Don\'t have an account? Sign up'));
    expect(toggled, isTrue);
  });
}
