import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/product_model.dart';

void main() {
  group('CartItem', () {
    final testProduct = Product(
      id: '1',
      collectionId: 'col1',
      name: 'Test Product',
      price: 10.0,
      onSale: false,
      imageUrl: 'http://example.com/image.jpg',
      sizes: ['S', 'M'],
      colors: ['Red', 'Blue'],
    );

    test('should create CartItem with required fields and default values', () {
      final cartItem = CartItem(product: testProduct);

      expect(cartItem.product, testProduct);
      expect(cartItem.quantity, 1);
      expect(cartItem.size, null);
      expect(cartItem.color, null);
      expect(cartItem.customText, null);
      expect(cartItem.customColorName, null);
    });

    test('should create CartItem with all fields', () {
      final cartItem = CartItem(
        product: testProduct,
        quantity: 2,
        size: 'M',
        color: 'Red',
        customText: 'Hello',
        customColorName: 'Custom Red',
      );

      expect(cartItem.product, testProduct);
      expect(cartItem.quantity, 2);
      expect(cartItem.size, 'M');
      expect(cartItem.color, 'Red');
      expect(cartItem.customText, 'Hello');
      expect(cartItem.customColorName, 'Custom Red');
    });

    test('should allow updating quantity', () {
      final cartItem = CartItem(product: testProduct);

      cartItem.quantity = 5;

      expect(cartItem.quantity, 5);
    });
  });
}
