import 'package:flutter/material.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/product_service.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/widgets/page_wrapper.dart';
import 'package:union_shop/widgets/product_card.dart';

class CollectionPage extends StatefulWidget {
  final String collectionId;
  final String collectionName;

  const CollectionPage({
    super.key,
    required this.collectionId,
    required this.collectionName,
  });

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture =
        _productService.getProductsByCollection(widget.collectionId);
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No products found in this collection.'));
          } else {
            final products = snapshot.data!;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PageWrapper(child: ProductPage(productId: product.id)),
                      ),
                    );
                  },
                  child: ProductCard(product: product),
                );
              },
            );
          }
        },
      ),
    );
  }
}

