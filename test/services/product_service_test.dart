import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/services/product_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ProductService productService;

  final mockProducts = [
    {
      "id": "1",
      "collectionId": "col1",
      "name": "Product 1",
      "price": 10.0,
      "onSale": false,
      "imageUrl": "url1",
      "sizes": [],
      "colors": []
    },
    {
      "id": "2",
      "collectionId": "col2",
      "name": "Product 2",
      "price": 20.0,
      "onSale": true,
      "salePrice": 15.0,
      "imageUrl": "url2",
      "sizes": [],
      "colors": []
    }
  ];

  setUp(() {
    productService = ProductService();

    // Mock the asset loading
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
      'flutter/assets',
      (ByteData? message) async {
        final String jsonStr = json.encode(mockProducts);
        final Uint8List utf8Bytes = utf8.encode(jsonStr);
        return ByteData.view(utf8Bytes.buffer);
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
      'flutter/assets',
      null,
    );
  });

  test('getAllProducts returns all products', () async {
    final products = await productService.getAllProducts();
    expect(products.length, 2);
    expect(products[0].name, 'Product 1');
  });

  test('getProductsByCollection returns filtered products', () async {
    final products = await productService.getProductsByCollection('col1');
    expect(products.length, 1);
    expect(products[0].id, '1');
  });

  test('getSaleProducts returns only sale products', () async {
    final products = await productService.getSaleProducts();
    expect(products.length, 1);
    expect(products[0].id, '2');
  });

  test('getProductById returns correct product', () async {
    final product = await productService.getProductById('1');
    expect(product.name, 'Product 1');
  });

  test('searchProducts returns matching products', () async {
    final products = await productService.searchProducts('Product 1');
    expect(products.length, 1);
    expect(products[0].name, 'Product 1');
  });

  test('searchProducts is case insensitive', () async {
    final products = await productService.searchProducts('product 1');
    expect(products.length, 1);
    expect(products[0].name, 'Product 1');
  });

  test('searchProducts returns empty list for empty query', () async {
    final products = await productService.searchProducts('');
    expect(products.isEmpty, true);
  });

  test('searchProducts returns empty list for no match', () async {
    final products = await productService.searchProducts('Nonexistent');
    expect(products.isEmpty, true);
  });
}
