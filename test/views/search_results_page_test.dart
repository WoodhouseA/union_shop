import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/views/search_results_page.dart';
import 'package:union_shop/widgets/product_card.dart';

class TestAssetBundle extends CachingAssetBundle {
  final List<Map<String, dynamic>> mockProducts;

  TestAssetBundle(this.mockProducts);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    if (key == 'assets/products.json') {
      return json.encode(mockProducts);
    }
    return super.loadString(key, cache: cache);
  }

  @override
  Future<ByteData> load(String key) async {
    if (key == 'assets/products.json') {
      final String jsonStr = json.encode(mockProducts);
      final Uint8List utf8Bytes = utf8.encode(jsonStr);
      return ByteData.view(utf8Bytes.buffer);
    }
    // Return transparent 1x1 PNG for images
    final List<int> pngBytes = base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==');
    return ByteData.view(Uint8List.fromList(pngBytes).buffer);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mockProducts = [
    {
      "id": "1",
      "collectionId": "col1",
      "name": "Apple",
      "price": 1.0,
      "onSale": false,
      "imageUrl": "assets/images/apple.png",
      "sizes": [],
      "colors": []
    },
    {
      "id": "2",
      "collectionId": "col1",
      "name": "Banana",
      "price": 2.0,
      "onSale": false,
      "imageUrl": "assets/images/banana.png",
      "sizes": [],
      "colors": []
    }
  ];

  Widget createWidgetUnderTest({String initialQuery = ''}) {
    final router = GoRouter(
      initialLocation: '/search',
      routes: [
        GoRoute(
          path: '/search',
          builder: (context, state) => DefaultAssetBundle(
            bundle: TestAssetBundle(mockProducts),
            child: Scaffold(
              body: SingleChildScrollView(
                child: SearchResultsPage(initialQuery: initialQuery),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) {
             final id = state.pathParameters['id'];
             return Scaffold(body: Text('Product $id'));
          },
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }

  testWidgets('shows results for initial query', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(initialQuery: 'Apple'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();

    expect(find.widgetWithText(ProductCard, 'Apple'), findsOneWidget);
    expect(find.widgetWithText(ProductCard, 'Banana'), findsNothing);
    expect(find.byType(ProductCard), findsOneWidget);
  });

  testWidgets('shows no results message when no match', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(initialQuery: 'Orange'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('No results found for "Orange"'), findsOneWidget);
    expect(find.byType(ProductCard), findsNothing);
  });

  testWidgets('search field updates results', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(initialQuery: ''));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();

    // Enter text
    await tester.enterText(find.byType(TextField), 'Banana');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    
    FocusManager.instance.primaryFocus?.unfocus();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();

    expect(find.widgetWithText(ProductCard, 'Banana'), findsOneWidget);
    expect(find.widgetWithText(ProductCard, 'Apple'), findsNothing);
  });
  
  testWidgets('navigates to product page on tap', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest(initialQuery: 'Apple'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();

    await tester.tap(find.widgetWithText(ProductCard, 'Apple'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();

    expect(find.text('Product 1'), findsOneWidget);
  });
}
