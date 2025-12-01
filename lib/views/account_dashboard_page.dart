import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class AccountDashboardPage extends StatelessWidget {
  const AccountDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthService>().currentUser;

    if (user == null) {
      return const Center(child: Text('Not logged in'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Dashboard',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Text(
            'Welcome, ${user.email}',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          const Text(
            'Order History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text('No orders yet.'),
          const SizedBox(height: 20),
          const Text(
            'Saved Addresses',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text('No saved addresses.'),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              await context.read<AuthService>().signOut();
              if (context.mounted) {
                context.go('/');
              }
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
