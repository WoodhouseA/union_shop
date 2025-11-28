import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product_model.dart';

void main() {
  group('Product', () {
    test('should create Product with required fields', () {
      final product = Product(
        id: '1',
        collectionId: 'col1',
        name: 'Test Product',
        price: 10.0,
        onSale: false,
        imageUrl: 'http://example.com/image.jpg',
        sizes: ['S', 'M'],
        colors: ['Red', 'Blue'],
      );

      expect(product.id, '1');
      expect(product.collectionId, 'col1');
      expect(product.name, 'Test Product');
      expect(product.price, 10.0);
      expect(product.onSale, false);
      expect(product.salePrice, null);
      expect(product.imageUrl, 'http://example.com/image.jpg');
      expect(product.sizes, ['S', 'M']);
      expect(product.colors, ['Red', 'Blue']);
    });

    test('fromJson should parse valid JSON correctly', () {
      final json = {
        'id': '1',
        'collectionId': 'col1',
        'name': 'Test Product',
        'price': 10.0,
        'onSale': true,
        'salePrice': 8.0,
        'imageUrl': 'http://example.com/image.jpg',
        'sizes': ['S', 'M'],
        'colors': ['Red', 'Blue'],
      };

      final product = Product.fromJson(json);

      expect(product.id, '1');
      expect(product.collectionId, 'col1');
      expect(product.name, 'Test Product');
      expect(product.price, 10.0);
      expect(product.onSale, true);
      expect(product.salePrice, 8.0);
      expect(product.imageUrl, 'http://example.com/image.jpg');
      expect(product.sizes, ['S', 'M']);
      expect(product.colors, ['Red', 'Blue']);
    });

    test('fromJson should handle int values for double fields', () {
      final json = {
        'id': '1',
        'collectionId': 'col1',
        'name': 'Test Product',
        'price': 10, // int
        'onSale': false,
        'salePrice': 8, // int
        'imageUrl': 'http://example.com/image.jpg',
        'sizes': [],
        'colors': [],
      };

      final product = Product.fromJson(json);

      expect(product.price, 10.0);
      expect(product.salePrice, 8.0);
    });

    test('fromJson should handle null salePrice', () {
      final json = {
        'id': '1',
        'collectionId': 'col1',
        'name': 'Test Product',
        'price': 10.0,
        'onSale': false,
        'salePrice': null,
        'imageUrl': 'http://example.com/image.jpg',
        'sizes': [],
        'colors': [],
      };

      final product = Product.fromJson(json);

      expect(product.salePrice, null);
    });

    test('fromJson should default onSale to false if missing', () {
      final json = {
        'id': '1',
        'collectionId': 'col1',
        'name': 'Test Product',
        'price': 10.0,
        // onSale missing
        'imageUrl': 'http://example.com/image.jpg',
        'sizes': [],
        'colors': [],
      };

      final product = Product.fromJson(json);

      expect(product.onSale, false);
    });
  });
}
