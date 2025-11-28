import 'package:flutter/foundation.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/product_model.dart';

class CartService with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  void addToCart(Product product) {
    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex != -1) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    final existingIndex = _items.indexWhere((item) => item.product.id == productId);
    if (existingIndex != -1) {
      if (quantity > 0) {
        _items[existingIndex].quantity = quantity;
      } else {
        removeFromCart(productId);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
