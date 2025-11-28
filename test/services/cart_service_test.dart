import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/cart_service.dart';

void main() {
  late CartService cartService;
  late Product testProduct;
  late Product saleProduct;

  setUp(() {
    cartService = CartService();
    testProduct = Product(
      id: '1',
      collectionId: 'col1',
      name: 'Test Product',
      price: 10.0,
      onSale: false,
      imageUrl: 'url',
      sizes: ['S', 'M'],
      colors: ['Red'],
    );
    saleProduct = Product(
      id: '2',
      collectionId: 'col1',
      name: 'Sale Product',
      price: 20.0,
      onSale: true,
      salePrice: 15.0,
      imageUrl: 'url',
      sizes: [],
      colors: [],
    );
  });

  group('CartService', () {
    test('initial state should be empty', () {
      expect(cartService.items, isEmpty);
      expect(cartService.totalItems, 0);
      expect(cartService.totalPrice, 0.0);
    });

    test('addToCart should add item', () {
      cartService.addToCart(testProduct, size: 'S', color: 'Red');
      expect(cartService.items.length, 1);
      expect(cartService.items.first.product, testProduct);
      expect(cartService.items.first.quantity, 1);
    });

    test('addToCart should not add if required options missing', () {
      // Missing size
      cartService.addToCart(testProduct, color: 'Red');
      expect(cartService.items, isEmpty);

      // Missing color
      cartService.addToCart(testProduct, size: 'S');
      expect(cartService.items, isEmpty);
    });

    test('addToCart should increment quantity for existing item', () {
      cartService.addToCart(testProduct, size: 'S', color: 'Red');
      cartService.addToCart(testProduct, size: 'S', color: 'Red');

      expect(cartService.items.length, 1);
      expect(cartService.items.first.quantity, 2);
    });

    test('addToCart should add separate items for different options', () {
      cartService.addToCart(testProduct, size: 'S', color: 'Red');
      cartService.addToCart(testProduct, size: 'M', color: 'Red');

      expect(cartService.items.length, 2);
    });

    test('removeFromCart should remove item', () {
      cartService.addToCart(testProduct, size: 'S', color: 'Red');
      cartService.removeFromCart(testProduct.id, 'S', 'Red');

      expect(cartService.items, isEmpty);
    });

    test('updateQuantity should update quantity', () {
      cartService.addToCart(testProduct, size: 'S', color: 'Red');
      cartService.updateQuantity(testProduct.id, 5, 'S', 'Red');

      expect(cartService.items.first.quantity, 5);
    });

    test('updateQuantity to 0 should remove item', () {
      cartService.addToCart(testProduct, size: 'S', color: 'Red');
      cartService.updateQuantity(testProduct.id, 0, 'S', 'Red');

      expect(cartService.items, isEmpty);
    });

    test('clearCart should remove all items', () {
      cartService.addToCart(testProduct, size: 'S', color: 'Red');
      cartService.addToCart(saleProduct);
      cartService.clearCart();

      expect(cartService.items, isEmpty);
    });

    test('totalPrice should calculate correctly', () {
      cartService.addToCart(testProduct,
          size: 'S', color: 'Red', quantity: 2); // 10 * 2 = 20
      cartService.addToCart(saleProduct, quantity: 1); // 15 * 1 = 15

      expect(cartService.totalPrice, 35.0);
    });
  });
}
