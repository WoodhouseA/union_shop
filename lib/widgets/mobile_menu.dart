import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileMenu extends StatelessWidget {
  const MobileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Home'),
              onTap: () {
                context.go('/');
              },
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                context.go('/about');
              },
            ),
            ListTile(
              title: const Text('Collections'),
              onTap: () {
                context.go('/collections');
              },
            ),
            ExpansionTile(
              title: const Text('The Print Shack'),
              children: [
                ListTile(
                  title: const Text('Personalization'),
                  contentPadding: const EdgeInsets.only(left: 32),
                  onTap: () {
                    context.go('/print-shack');
                  },
                ),
                ListTile(
                  title: const Text('About'),
                  contentPadding: const EdgeInsets.only(left: 32),
                  onTap: () {
                    context.go('/print-shack-about');
                  },
                ),
              ],
            ),
            ListTile(
              title: const Text('Sale!'),
              onTap: () {
                context.go('/sale');
              },
            ),
          ],
        ),
      ),
    );
  }
}
