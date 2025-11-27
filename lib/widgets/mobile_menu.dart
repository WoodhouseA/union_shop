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
