import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/order_model.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/services/order_service.dart';

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
          StreamBuilder<List<OrderModel>>(
            stream: context.read<OrderService>().getUserOrders(user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No orders yet.');
              } else {
                final orders = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Order #${order.id.substring(0, 8)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '£${order.totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Date: ${order.date.toString().split('.')[0]}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Text('Status: ${order.status}'),
                              const Divider(),
                              ...order.items.map((item) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${item.quantity}x ${item.product.name}',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                            '£${(item.product.price * item.quantity).toStringAsFixed(2)}'),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signed out successfully')),
                );
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
