import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/order_service.dart';

void main() {
  group('OrderService', () {
    late FakeFirebaseFirestore fakeFirestore;
    late OrderService orderService;

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      orderService = OrderService(firestore: fakeFirestore);
    });

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
  });
}
