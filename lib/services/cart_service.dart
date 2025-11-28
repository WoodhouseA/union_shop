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

  void addToCart(Product product,
      {String? size,
      String? color,
      String? customText,
      String? customColorName,
      int quantity = 1}) {
    // If the product has sizes but no size is selected, do not add to cart.
    if (product.sizes.isNotEmpty && size == null) {
      return;
    }
    // If the product has colors but no color is selected, do not add to cart.
    if (product.colors.isNotEmpty && color == null) {
      return;
    }

    final existingIndex = _items.indexWhere((item) =>
        item.product.id == product.id &&
        item.size == size &&
        item.color == color &&
        item.customText == customText &&
        item.customColorName == customColorName);

    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        product: product,
        quantity: quantity,
        size: size,
        color: color,
        customText: customText,
        customColorName: customColorName,
      ));
    }
    notifyListeners();
  }

  void removeFromCart(String productId, String? size, String? color,
      {String? customText, String? customColorName}) {
    _items.removeWhere((item) =>
        item.product.id == productId &&
        item.size == size &&
        item.color == color &&
        item.customText == customText &&
        item.customColorName == customColorName);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity, String? size, String? color,
      {String? customText, String? customColorName}) {
    final existingIndex = _items.indexWhere((item) =>
        item.product.id == productId &&
        item.size == size &&
        item.color == color &&
        item.customText == customText &&
        item.customColorName == customColorName);
    if (existingIndex != -1) {
      if (quantity > 0) {
        _items[existingIndex].quantity = quantity;
      } else {
        removeFromCart(productId, size, color,
            customText: customText,
            customColorName: customColorName);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
