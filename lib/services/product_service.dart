import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:union_shop/models/product_model.dart';

class ProductService {
  Future<List<Product>> _loadProducts() async {
    final String jsonString =
        await rootBundle.loadString('assets/products.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((data) => Product.fromJson(data)).toList();
  }

  Future<List<Product>> getProductsByCollection(String collectionId) async {
    final List<Product> allProducts = await _loadProducts();
    return allProducts
        .where((product) => product.collectionId == collectionId)
        .toList();
  }

  Future<List<Product>> getSaleProducts() async {
    final products = await _loadProducts();
    return products.where((p) => p.onSale).toList();
  }

  Future<Product> getProductById(String productId) async {
    final List<Product> allProducts = await _loadProducts();
    return allProducts.firstWhere((product) => product.id == productId);
  }
}
