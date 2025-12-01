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

  });
}
