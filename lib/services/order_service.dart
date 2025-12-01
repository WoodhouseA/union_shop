import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/order_model.dart';

class OrderService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(String userId, List<CartItem> items, double totalPrice) async {
    try {
      if (kDebugMode) {
        print('Starting placeOrder for user: $userId');
      }
      final docRef = _firestore.collection('orders').doc();
      final order = OrderModel(
        id: docRef.id,
        userId: userId,
        items: items,
        totalPrice: totalPrice,
        date: DateTime.now(),
      );

      if (kDebugMode) {
        print('Saving order to Firestore: ${docRef.id}');
      }
      await docRef.set(order.toJson());
      if (kDebugMode) {
        print('Order saved successfully');
      }
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error placing order: $e');
      }
      rethrow;
    }
  }

  Stream<List<OrderModel>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final orders = snapshot.docs.map((doc) {
        return OrderModel.fromJson(doc.data());
      }).toList();
      // Sort in memory to avoid Firestore composite index requirement
      orders.sort((a, b) => b.date.compareTo(a.date));
      return orders;
    });
  }
}
