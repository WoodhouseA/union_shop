import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:union_shop/models/product_model.dart';

class ProductService {
  Future<List<Product>> getProductsByCollection(String collectionId) async {
    final String jsonString =
        await rootBundle.loadString('assets/products.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    final List<Product> allProducts =
        jsonResponse.map((data) => Product.fromJson(data)).toList();
    return allProducts
        .where((product) => product.collectionId == collectionId)
        .toList();
  }
}
