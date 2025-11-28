import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/widgets/mobile_menu.dart';

void main() {
  Widget createTestWidget({GoRouter? router}) {
    return MaterialApp.router(
      routerConfig: router ??
          GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const Scaffold(body: MobileMenu()),
              ),
              GoRoute(
                path: '/about',
                builder: (context, state) =>
                    const Scaffold(body: Text('About Page')),
              ),
              GoRoute(
                path: '/collections',
                builder: (context, state) =>
                    const Scaffold(body: Text('Collections Page')),
              ),
              GoRoute(
                path: '/sale',
                builder: (context, state) =>
                    const Scaffold(body: Text('Sale Page')),
              ),
              GoRoute(
                path: '/print-shack',
                builder: (context, state) =>
                    const Scaffold(body: Text('Print Shack Page')),
              ),
              GoRoute(
                path: '/print-shack-about',
                builder: (context, state) =>
                    const Scaffold(body: Text('Print Shack About Page')),
              ),
            ],
          ),
    );
  }
}
