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

    test('placeOrder should add order to Firestore', () async {
      await orderService.placeOrder('user1', [testItem], 20.0);

      final snapshot = await fakeFirestore.collection('orders').get();
      expect(snapshot.docs.length, 1);
      
      final data = snapshot.docs.first.data();
      expect(data['userId'], 'user1');
      expect(data['totalPrice'], 20.0);
      expect((data['items'] as List).length, 1);
    });

    test('getUserOrders should return stream of orders for user', () async {
      // Add some orders
      await orderService.placeOrder('user1', [testItem], 20.0);
      await orderService.placeOrder('user1', [testItem], 30.0);
      await orderService.placeOrder('user2', [testItem], 40.0); // Different user

      final stream = orderService.getUserOrders('user1');

      expect(stream, emits(predicate<List<dynamic>>((orders) {
        return orders.length == 2 &&
            orders.every((order) => order.userId == 'user1');
      })));
    });
  });
}
