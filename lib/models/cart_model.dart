import 'package:union_shop/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  final String? size;
  final String? color;
  final String? customText;
  final String? customColorName;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.size,
    this.color,
    this.customText,
    this.customColorName,
  });
}
