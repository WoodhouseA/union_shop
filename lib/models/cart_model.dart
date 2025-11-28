import 'package:union_shop/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;
  final String? size;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.size,
  });
}
