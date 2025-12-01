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

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'size': size,
      'color': color,
      'customText': customText,
      'customColorName': customColorName,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
      size: json['size'],
      color: json['color'],
      customText: json['customText'],
      customColorName: json['customColorName'],
    );
  }
}
