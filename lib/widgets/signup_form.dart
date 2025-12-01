import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupForm extends StatefulWidget {
  final VoidCallback onToggle;

  const SignupForm({super.key, required this.onToggle});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign Up',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await context.read<AuthService>().signUp(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                    if (context.mounted) {
                      context.go('/');
                    }
                  } on FirebaseAuthException catch (e) {
                    String message;
                    if (e.code == 'weak-password') {
                      message = 'The password provided is too weak.';
                    } else if (e.code == 'email-already-in-use') {
                      message = 'The account already exists for that email.';
                    } else if (e.code == 'invalid-email') {
                      message = 'The email address is invalid.';
                    } else {
                      message = 'Sign up failed: ${e.message}';
                    }
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sign up failed: $e')),
                      );
                    }
                  }
                }
              },
              child: const Text('Sign Up'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: widget.onToggle,
              child: const Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
