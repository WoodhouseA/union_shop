import 'package:flutter/material.dart';

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
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false);
              },
            ),
            ListTile(
              title: const Text('About Us'),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
            ListTile(
              title: const Text('Collections'),
              onTap: () {
                Navigator.pushNamed(context, '/collections');
              },
            ),
            ExpansionTile(
              title: const Text('The Print Shack'),
              children: [
                ListTile(
                  title: const Text('Personalization'),
                  contentPadding: const EdgeInsets.only(left: 32),
                  onTap: () {
                    Navigator.pushNamed(context, '/print-shack');
                  },
                ),
                ListTile(
                  title: const Text('About'),
                  contentPadding: const EdgeInsets.only(left: 32),
                  onTap: () {
                    Navigator.pushNamed(context, '/print-shack-about');
                  },
                ),
              ],
            ),
            ListTile(
              title: const Text('Sale!'),
              onTap: () {
                Navigator.pushNamed(context, '/sale');
              },
            ),
            ListTile(
              title: const Text('Products'),
              onTap: () {
                Navigator.pushNamed(context, '/product');
              },
            ),
          ],
        ),
      ),
    );
  }
}
