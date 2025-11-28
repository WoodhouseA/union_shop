import 'package:flutter/material.dart';
import 'package:union_shop/widgets/login_form.dart';
import 'package:union_shop/widgets/signup_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _showLoginPage = true;

  void _toggleScreens() {
    setState(() {
      _showLoginPage = !_showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: _showLoginPage
              ? LoginForm(onToggle: _toggleScreens)
              : SignupForm(onToggle: _toggleScreens),
        ),
      ),
    );
  }
}
