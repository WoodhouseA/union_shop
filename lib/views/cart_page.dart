import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/services/order_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final orderService = Provider.of<OrderService>(context, listen: false);
    final cartItems = cartService.items;

    return cartItems.isEmpty
        ? const Center(
            child: Text('Your cart is empty.'),
          )
        : Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: SingleChildScrollView(
                child: Column(
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
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 50),
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
                                onPressed: _isLoading
                                    ? null
                                    : () {
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
                                onPressed: _isLoading
                                    ? null
                                    : () {
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
                                onPressed: _isLoading
                                    ? null
                                    : () {
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
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    final user = authService.currentUser;
                                    if (user == null) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text('Please login to checkout.'),
                                          ),
                                        );
                                        context.go('/auth');
                                      }
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      return;
                                    }

                                    try {
                                      await orderService.placeOrder(
                                        user.uid,
                                        List.from(cartItems),
                                        cartService.totalPrice,
                                      );
                                      cartService.clearCart();
                                      if (context.mounted) {
                                        showDialog(
                                          context: context,
                                          builder: (dialogContext) => AlertDialog(
                                            title: const Text('Order Placed'),
                                            content: const Text(
                                                'Your order has been placed successfully!'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  dialogContext.pop();
                                                  context.go('/account');
                                                },
                                                child: const Text('View Orders'),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('Failed to place order: $e'),
                                          ),
                                        );
                                      }
                                    } finally {
                                      if (mounted) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    }
                                  },
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Checkout'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
