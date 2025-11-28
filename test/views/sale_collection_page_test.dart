import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/views/sale_collection_page.dart';

void main() {
  final defaultMockProducts = [
    {
      "id": "prod-001",
      "collectionId": "summer",
      "name": "Sale Product 1",
      "price": 20.0,
      "onSale": true,
      "salePrice": 15.0,
      "imageUrl": "https://example.com/img1.jpg",
      "sizes": ["S"],
      "colors": ["Red"]
    },
    {
      "id": "prod-002",
      "collectionId": "winter",
      "name": "Regular Product",
      "price": 30.0,
      "onSale": false,
      "salePrice": null,
      "imageUrl": "https://example.com/img2.jpg",
      "sizes": ["M"],
      "colors": ["Blue"]
    },
    {
      "id": "prod-003",
      "collectionId": "summer",
      "name": "Sale Product 2",
      "price": 50.0,
      "onSale": true,
      "salePrice": 40.0,
      "imageUrl": "https://example.com/img3.jpg",
      "sizes": ["L"],
      "colors": ["Green"]
    }
  ];

  List<Map<String, dynamic>> currentMockProducts = [];

  setUp(() {
    rootBundle.evict('assets/products.json');
    currentMockProducts = List.from(defaultMockProducts);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (ByteData? message) async {
        if (message == null) return null;
        final key = utf8.decode(message.buffer.asUint8List(message.offsetInBytes, message.lengthInBytes));
        // print('MockAssets: Requested $key');
        
        if (key == 'assets/products.json') {
          final String jsonStr = json.encode(currentMockProducts);
          final Uint8List encoded = utf8.encode(jsonStr);
          return ByteData.view(encoded.buffer);
        }
        return null;
      },
    );
  });
}
