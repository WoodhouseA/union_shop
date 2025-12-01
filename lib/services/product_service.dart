import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:union_shop/models/product_model.dart';

class ProductService {
  Future<List<Product>> _loadProducts([AssetBundle? bundle]) async {
    final b = bundle ?? rootBundle;
    final String jsonString =
        await b.loadString('assets/products.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.map((data) => Product.fromJson(data)).toList();
  }

  Future<List<Product>> getProductsByCollection(String collectionId, {AssetBundle? bundle}) async {
    final List<Product> allProducts = await _loadProducts(bundle);
    return allProducts
        .where((product) => product.collectionId == collectionId)
        .toList();
  }

  Future<List<Product>> getSaleProducts({AssetBundle? bundle}) async {
    final products = await _loadProducts(bundle);
    return products.where((p) => p.onSale).toList();
  }

  Future<List<Product>> getAllProducts({AssetBundle? bundle}) async {
    return await _loadProducts(bundle);
  }

  Future<Product> getProductById(String productId, {AssetBundle? bundle}) async {
    final List<Product> allProducts = await _loadProducts(bundle);
    return allProducts.firstWhere((product) => product.id == productId);
  }

  Future<List<Product>> searchProducts(String query, {AssetBundle? bundle}) async {
    if (query.isEmpty) return [];
    final products = await _loadProducts(bundle);
    final lowerQuery = query.toLowerCase();
    return products.where((p) {
      return p.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }
}
