import 'package:flutter/foundation.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/product_model.dart';

class CartService with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice {
    return _items.fold(0.0, (sum, item) {
      final price = (item.product.onSale && item.product.salePrice != null)
          ? item.product.salePrice!
          : item.product.price;
      return sum + (price * item.quantity);
    });
  }

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void addToCart(Product product, {String? size, String? color}) {
    // If the product has sizes but no size is selected, do not add to cart.
    if (product.sizes.isNotEmpty && size == null) {
      return;
    }
    // If the product has colors but no color is selected, do not add to cart.
    if (product.colors.isNotEmpty && color == null) {
      return;
    }

    final existingIndex = _items.indexWhere(
        (item) => item.product.id == product.id && item.size == size && item.color == color);
        
    if (existingIndex != -1) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product, size: size, color: color));
    }
    notifyListeners();
  }

  void removeFromCart(String productId, String? size, String? color) {
    _items.removeWhere(
        (item) => item.product.id == productId && item.size == size && item.color == color);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity, String? size, String? color) {
    final existingIndex = _items
        .indexWhere((item) => item.product.id == productId && item.size == size && item.color == color);
    if (existingIndex != -1) {
      if (quantity > 0) {
        _items[existingIndex].quantity = quantity;
      } else {
        removeFromCart(productId, size, color);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
