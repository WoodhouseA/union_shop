import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/services/auth_service.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late AuthService authService;

  setUp(() {
    mockAuth = MockFirebaseAuth();
    authService = AuthService(auth: mockAuth);
  });

  group('AuthService', () {
    test('initial user should be null', () {
      expect(authService.currentUser, isNull);
    });

    test('signIn should sign in user', () async {
      // Create a user in the mock auth first
      await mockAuth.createUserWithEmailAndPassword(
          email: 'test@example.com', password: 'password');

      final user = await authService.signIn('test@example.com', 'password');
      expect(user, isNotNull);
      expect(user!.email, 'test@example.com');
      expect(authService.currentUser, isNotNull);
    });
  });
}
