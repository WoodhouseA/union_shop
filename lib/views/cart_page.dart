import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/widgets/app_bar.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final cartItems = cartService.items;

    return Scaffold(
      appBar: CustomAppBar(onMenuPressed: () {  },),
      body: cartItems.isEmpty
          ? const Center(
              child: Text('Your cart is empty.'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return ListTile(
                        leading: Image.network(
                          item.product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(item.product.name),
                        subtitle: Text('£${item.product.price.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                cartService.updateQuantity(item.product.id, item.quantity - 1);
                              },
                            ),
                            Text(item.quantity.toString()),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                cartService.updateQuantity(item.product.id, item.quantity + 1);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                cartService.removeFromCart(item.product.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: £${cartService.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Checkout'),
                              content: const Text('This is a simulated checkout. Your order has been placed!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    cartService.clearCart();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
