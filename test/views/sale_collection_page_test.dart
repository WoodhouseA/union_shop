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
        
        if (key == 'assets/products.json') {
          final String jsonStr = json.encode(currentMockProducts);
          final Uint8List encoded = utf8.encode(jsonStr);
          return ByteData.view(encoded.buffer);
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      null,
    );
  });

  Widget createWidgetUnderTest() {
    return const MaterialApp(
      home: Scaffold(
        body: SaleCollectionPage(),
      ),
    );
  }

  Future<void> waitForLoad(WidgetTester tester) async {
    await tester.pump();
    for (int i = 0; i < 100; i++) {
      await tester.pump(const Duration(milliseconds: 50));
      if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
        return;
      }
    }
    try {
      await tester.pumpAndSettle(const Duration(milliseconds: 100), EnginePhase.sendSemanticsUpdate, const Duration(seconds: 2));
      if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
        return;
      }
    } catch (e) {
      // Ignore
    }
    throw Exception('Timed out waiting for products to load');
  }

  testWidgets('displays only sale products', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await waitForLoad(tester);

    expect(find.text('Sale!'), findsOneWidget);
    expect(find.text('Sale Product 1'), findsOneWidget);
    expect(find.text('Sale Product 2'), findsOneWidget);
    expect(find.text('Regular Product'), findsNothing);
    
    // Check prices
    expect(find.text('£15.00'), findsOneWidget); // Sale price for prod 1
    expect(find.text('£40.00'), findsOneWidget); // Sale price for prod 2
  });

  testWidgets('displays message when no sale products found', (WidgetTester tester) async {
    // Only regular products
    currentMockProducts = [
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
      }
    ];

    await tester.pumpWidget(createWidgetUnderTest());
    await waitForLoad(tester);

    expect(find.text('No sale products found.'), findsOneWidget);
    expect(find.text('Regular Product'), findsNothing);
  });
}
