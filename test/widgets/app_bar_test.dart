import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/widgets/app_bar.dart';

class MockCartService extends ChangeNotifier implements CartService {
  @override
  List<CartItem> get items => [];
  @override
  int get totalItems => 0;
  @override
  double get totalPrice => 0.0;

  @override
  void addToCart(Product product,
      {String? size,
      String? color,
      String? customText,
      String? customColorName,
      int quantity = 1}) {}

  @override
  void clearCart() {}

  @override
  void removeFromCart(String productId, String? size, String? color,
      {String? customText, String? customColorName}) {}

  @override
  void updateQuantity(
      String productId, int quantity, String? size, String? color,
      {String? customText, String? customColorName}) {}
}

