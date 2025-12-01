import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/product_model.dart';

class CartService with ChangeNotifier {
  List<CartItem> _items = [];
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  User? _user;

  CartService({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance {
    _auth.authStateChanges().listen((user) {
      _user = user;
      if (user != null) {
        _loadCart();
      } else {
        _items.clear();
        notifyListeners();
      }
    });
  }

  List<CartItem> get items => _items;

  double get totalPrice {
    return _items.fold(0.0, (currentTotal, item) {
      final price = (item.product.onSale && item.product.salePrice != null)
          ? item.product.salePrice!
          : item.product.price;
      return currentTotal + (price * item.quantity);
    });
  }

  int get totalItems {
    return _items.fold(0, (currentTotal, item) => currentTotal + item.quantity);
  }

  Future<void> _loadCart() async {
    if (_user == null) return;
    try {
      final doc = await _firestore.collection('users').doc(_user!.uid).get();
      if (doc.exists && doc.data() != null && doc.data()!.containsKey('cart')) {
        final List<dynamic> cartData = doc.data()!['cart'];
        _items = cartData.map((item) => CartItem.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  Future<void> _saveCart() async {
    if (_user == null) return;
    try {
      final cartData = _items.map((item) => item.toJson()).toList();
      await _firestore.collection('users').doc(_user!.uid).set({
        'cart': cartData,
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
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
    _saveCart();
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
    _saveCart();
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
        return;
      }
      notifyListeners();
      _saveCart();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveCart();
  }
}
