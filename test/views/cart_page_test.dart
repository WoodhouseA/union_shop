import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/views/cart_page.dart';

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = false;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _MockHttpClientRequest();
  }
}

class _MockHttpClientRequest extends Fake implements HttpClientRequest {
  @override
  HttpHeaders get headers => _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return _MockHttpClientResponse();
  }
}

class _MockHttpHeaders extends Fake implements HttpHeaders {}

class _MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => _transparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.value(_transparentImage).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
}

final List<int> _transparentImage = [
  0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00, 0x00,
  0x00, 0x00, 0x00, 0xff, 0xff, 0xff, 0x21, 0xf9, 0x04, 0x01, 0x00, 0x00, 0x00,
  0x00, 0x2c, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0x02, 0x02,
  0x44, 0x01, 0x00, 0x3b
];

void main() {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  testWidgets('CartPage displays empty message when cart is empty',
      (WidgetTester tester) async {
    final cartService = CartService();

    await tester.pumpWidget(
      ChangeNotifierProvider<CartService>.value(
        value: cartService,
        child: const MaterialApp(
          home: Scaffold(body: CartPage()),
        ),
      ),
    );

    expect(find.text('Your cart is empty.'), findsOneWidget);
  });

  testWidgets('CartPage displays items and total', (WidgetTester tester) async {
    final cartService = CartService();
    final product = Product(
      id: '1',
      collectionId: 'col1',
      name: 'Test Product',
      price: 20.0,
      onSale: false,
      imageUrl: 'https://example.com/image.jpg',
      sizes: ['M'],
      colors: ['Red'],
    );

    cartService.addToCart(product, size: 'M', color: 'Red');

    await tester.pumpWidget(
      ChangeNotifierProvider<CartService>.value(
        value: cartService,
        child: const MaterialApp(
          home: Scaffold(body: CartPage()),
        ),
      ),
    );

    // Allow image loading
    await tester.pump();

    expect(find.text('Test Product'), findsOneWidget);
    expect(find.text('£20.00'), findsOneWidget); // One in list
    expect(find.text('Total: £20.00'), findsOneWidget);
    expect(find.text('Size: M'), findsOneWidget);
    expect(find.text('Color: Red'), findsOneWidget);
  });

  testWidgets('CartPage updates quantity and removes item',
      (WidgetTester tester) async {
    final cartService = CartService();
    final product = Product(
      id: '1',
      collectionId: 'col1',
      name: 'Test Product',
      price: 20.0,
      onSale: false,
      imageUrl: 'https://example.com/image.jpg',
      sizes: ['M'],
      colors: ['Red'],
    );

    cartService.addToCart(product, size: 'M', color: 'Red');

    await tester.pumpWidget(
      ChangeNotifierProvider<CartService>.value(
        value: cartService,
        child: const MaterialApp(
          home: Scaffold(body: CartPage()),
        ),
      ),
    );

    // Increment
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(cartService.items.first.quantity, 2);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('Total: £40.00'), findsOneWidget);

    // Decrement
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(cartService.items.first.quantity, 1);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('Total: £20.00'), findsOneWidget);

    // Delete
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();
    expect(cartService.items.isEmpty, true);
    expect(find.text('Your cart is empty.'), findsOneWidget);
  });

  testWidgets('CartPage checkout clears cart', (WidgetTester tester) async {
    final cartService = CartService();
    final product = Product(
      id: '1',
      collectionId: 'col1',
      name: 'Test Product',
      price: 20.0,
      onSale: false,
      imageUrl: 'https://example.com/image.jpg',
      sizes: ['M'],
      colors: ['Red'],
    );

    cartService.addToCart(product, size: 'M', color: 'Red');

    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: CartPage()),
        ),
      ],
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<CartService>.value(
        value: cartService,
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Checkout'), findsNWidgets(2)); // Button and Dialog Title
    expect(find.text('This is a simulated checkout. Your order has been placed!'),
        findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(cartService.items.isEmpty, true);
    expect(find.text('Your cart is empty.'), findsOneWidget);
  });
}
