import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/widgets/product_card.dart';

void main() {
  Widget createTestWidget(Product product) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 300, // Increased width to prevent overflow
          height: 300,
          child: ProductCard(product: product),
        ),
      ),
    );
  }

  testWidgets('ProductCard displays regular product info', (WidgetTester tester) async {
    final product = Product(
      id: '1',
      collectionId: 'col1',
      name: 'Test Product',
      price: 10.0,
      onSale: false,
      imageUrl: 'http://example.com/image.jpg',
      sizes: [],
      colors: [],
    );

    await tester.pumpWidget(createTestWidget(product));

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('£10.00'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('ProductCard displays sale product info', (WidgetTester tester) async {
    final product = Product(
      id: '2',
      collectionId: 'col1',
      name: 'Sale Product',
      price: 20.0,
      onSale: true,
      salePrice: 15.0,
      imageUrl: 'http://example.com/image.jpg',
      sizes: [],
      colors: [],
    );

    await tester.pumpWidget(createTestWidget(product));

    expect(find.text('Sale Product'), findsOneWidget);
    expect(find.text('£20.00'), findsOneWidget); // Original price
    expect(find.text('£15.00'), findsOneWidget); // Sale price
    
    // Check for strikethrough style on original price
    final originalPriceFinder = find.text('£20.00');
    final Text originalPriceText = tester.widget(originalPriceFinder);
    expect(originalPriceText.style?.decoration, TextDecoration.lineThrough);
    
    // Check for red color on sale price
    final salePriceFinder = find.text('£15.00');
    final Text salePriceText = tester.widget(salePriceFinder);
    expect(salePriceText.style?.color, Colors.red);
  });
}
