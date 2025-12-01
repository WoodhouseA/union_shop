import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/order_model.dart';
import 'package:union_shop/models/product_model.dart';

void main() {
  group('OrderModel', () {
    final testProduct = Product(
      id: '1',
      collectionId: 'col1',
      name: 'Test Product',
      price: 10.0,
      onSale: false,
      imageUrl: 'http://example.com/image.jpg',
      sizes: ['S'],
      colors: ['Red'],
    );

    final testItem = CartItem(
      product: testProduct,
      quantity: 2,
      size: 'S',
      color: 'Red',
    );

    final testDate = DateTime(2023, 1, 1, 12, 0, 0);
    final testTimestamp = Timestamp.fromDate(testDate);

    test('should create OrderModel with required fields', () {
      final order = OrderModel(
        id: 'order1',
        userId: 'user1',
        items: [testItem],
        totalPrice: 20.0,
        date: testDate,
      );

      expect(order.id, 'order1');
      expect(order.userId, 'user1');
      expect(order.items.length, 1);
      expect(order.items.first.product.id, '1');
      expect(order.totalPrice, 20.0);
      expect(order.date, testDate);
      expect(order.status, 'Pending'); // Default value
    });
  });
}
