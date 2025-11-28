import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/services/cart_service.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final cartItems = cartService.items;

    return cartItems.isEmpty
        ? const Center(
            child: Text('Your cart is empty.'),
          )
        : Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (item.product.onSale &&
                              item.product.salePrice != null)
                            Row(
                              children: [
                                Text(
                                  '£${item.product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '£${item.product.salePrice!.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            )
                          else
                            Text('£${item.product.price.toStringAsFixed(2)}'),
                          if (item.size != null) Text('Size: ${item.size}'),
                          if (item.color != null) Text('Color: ${item.color}'),
                          if (item.customText != null)
                            Text('Text: ${item.customText}'),
                          if (item.customColorName != null)
                            Text('Print Color: ${item.customColorName}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              cartService.updateQuantity(
                                item.product.id,
                                item.quantity - 1,
                                item.size,
                                item.color,
                                customText: item.customText,
                                customColorName: item.customColorName,
                              );
                            },
                          ),
                          Text(item.quantity.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              cartService.updateQuantity(
                                item.product.id,
                                item.quantity + 1,
                                item.size,
                                item.color,
                                customText: item.customText,
                                customColorName: item.customColorName,
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              cartService.removeFromCart(
                                item.product.id,
                                item.size,
                                item.color,
                                customText: item.customText,
                                customColorName: item.customColorName,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: £${cartService.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Checkout'),
                            content: const Text(
                                'This is a simulated checkout. Your order has been placed!'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  cartService.clearCart();
                                  context.pop();
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
          );
  }
}
