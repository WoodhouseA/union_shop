import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/views/account_dashboard_page.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- Mock AuthService ---

class MockAuthService extends ChangeNotifier implements AuthService {
  User? _currentUser;

  MockAuthService({User? currentUser}) : _currentUser = currentUser;

  @override
  User? get currentUser => _currentUser;

  @override
  Stream<User?> get authStateChanges => Stream.value(_currentUser);

  @override
  Future<User?> signIn(String email, String password) async {
    return null;
  }

  @override
  Future<User?> signUp(String email, String password) async {
    return null;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }
}

// --- Mock User ---
class MockUser extends Fake implements User {
  final String _email;
  MockUser(this._email);

  @override
  String? get email => _email;
}

void main() {
}
