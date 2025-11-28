import 'package:flutter/material.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/product_service.dart';
import 'package:union_shop/widgets/page_wrapper.dart';
import 'package:union_shop/widgets/product_card.dart';

class SaleCollectionPage extends StatefulWidget {
  const SaleCollectionPage({super.key});

  @override
  State<SaleCollectionPage> createState() => _SaleCollectionPageState();
}

class _SaleCollectionPageState extends State<SaleCollectionPage> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _saleProductsFuture;

  @override
  void initState() {
    super.initState();
    _saleProductsFuture = _productService.getSaleProducts();
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      child: FutureBuilder<List<Product>>(
        future: _saleProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No sale products found.'));
          } else {
            final saleProducts = snapshot.data!;
            return SaleContent(saleProducts: saleProducts);
          }
        },
      ),
    );
  }
}

class SaleContent extends StatelessWidget {
  final List<Product> saleProducts;
  const SaleContent({super.key, required this.saleProducts});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sale',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                color: Colors.red,
                padding: const EdgeInsets.all(12.0),
                child: const Center(
                  child: Text(
                    'Limited Time Offers! Grab a bargain now!',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200.0,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
              childAspectRatio: 0.75,
            ),
            itemCount: saleProducts.length,
            itemBuilder: (BuildContext context, int index) {
              return ProductCard(product: saleProducts[index]);
            },
          ),
        ),
      ],
    );
  }
}
