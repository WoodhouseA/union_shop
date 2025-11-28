import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/product_service.dart';
import 'package:union_shop/views/collection_page.dart';
import 'package:union_shop/widgets/product_card.dart';

// Mock ProductService
class MockProductService extends ProductService {
  final List<Product> mockProducts;
  final bool shouldFail;

  MockProductService({this.mockProducts = const [], this.shouldFail = false});

  @override
  Future<List<Product>> getProductsByCollection(String collectionId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));

    if (shouldFail) {
      throw Exception('Failed to load products');
    }
    return mockProducts;
  }
}

void main() {
  final testProducts = [
    Product(
      id: '1',
      collectionId: 'col1',
      name: 'Product A',
      price: 10.0,
      onSale: false,
      imageUrl: 'http://example.com/a.jpg',
      sizes: [],
      colors: [],
    ),
    Product(
      id: '2',
      collectionId: 'col1',
      name: 'Product B',
      price: 20.0,
      onSale: true,
      salePrice: 15.0,
      imageUrl: 'http://example.com/b.jpg',
      sizes: [],
      colors: [],
    ),
    Product(
      id: '3',
      collectionId: 'col1',
      name: 'Product C',
      price: 30.0,
      onSale: false,
      imageUrl: 'http://example.com/c.jpg',
      sizes: [],
      colors: [],
    ),
  ];

  Widget createWidgetUnderTest(ProductService productService) {
    final router = GoRouter(
      initialLocation: '/collection/col1',
      routes: [
        GoRoute(
          path: '/collection/:id',
          builder: (context, state) => Scaffold(
            body: SingleChildScrollView(
              child: CollectionPage(
                collectionId: state.pathParameters['id']!,
                collectionName: 'Test Collection',
                productService: productService,
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) => Scaffold(body: Text('Product ${state.pathParameters['id']}')),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }

  testWidgets('shows loading indicator initially', (WidgetTester tester) async {
    final mockService = MockProductService(mockProducts: testProducts);
    await tester.pumpWidget(createWidgetUnderTest(mockService));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle(); // Finish loading
  });

  testWidgets('shows products after loading', (WidgetTester tester) async {
    final mockService = MockProductService(mockProducts: testProducts);
    await tester.pumpWidget(createWidgetUnderTest(mockService));
    await tester.pumpAndSettle();

    expect(find.byType(ProductCard), findsNWidgets(3));
    expect(find.text('Product A'), findsOneWidget);
    expect(find.text('Product B'), findsOneWidget);
    expect(find.text('Product C'), findsOneWidget);
  });

  testWidgets('shows error message on failure', (WidgetTester tester) async {
    final mockService = MockProductService(shouldFail: true);
    await tester.pumpWidget(createWidgetUnderTest(mockService));
    await tester.pumpAndSettle();

    expect(find.textContaining('Error'), findsOneWidget);
  });
}
