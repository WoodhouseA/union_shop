import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/router.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/views/about_us_page.dart';
import 'package:union_shop/views/cart_page.dart';
import 'package:union_shop/views/collections_page.dart';
import 'package:union_shop/views/sale_collection_page.dart';
import 'package:union_shop/views/auth_page.dart';
import 'package:union_shop/views/collection_page.dart';
import 'package:union_shop/views/print_shack_about_page.dart';
import 'package:union_shop/views/print_shack_page.dart';
import 'package:union_shop/views/product_page.dart';

// --- Mock HttpOverrides for NetworkImage ---

class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

class MockHttpClient extends Fake implements HttpClient {
  @override
  bool autoUncompress = false;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    // Fail images to avoid hanging
    if (url.toString().endsWith('.png')) {
      return MockHttpClientRequest(statusCode: 404);
    }
    return MockHttpClientRequest(statusCode: 200);
  }
}

class MockHttpClientRequest extends Fake implements HttpClientRequest {
  final int statusCode;
  MockHttpClientRequest({required this.statusCode});

  @override
  HttpHeaders get headers => MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return MockHttpClientResponse(statusCode: statusCode);
  }
}

class MockHttpHeaders extends Fake implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class MockHttpClientResponse extends Fake implements HttpClientResponse {
  final int _statusCode;
  MockHttpClientResponse({required int statusCode}) : _statusCode = statusCode;

  @override
  int get statusCode => _statusCode;

  @override
  int get contentLength => kTransparentImage.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    if (_statusCode == 200) {
      return Stream<List<int>>.fromIterable([kTransparentImage]).listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);
    } else {
      // For 404, we might not send body, or send error.
      // Just closing the stream empty or throwing error.
      // Image.network handles 404 by throwing exception internally which triggers errorBuilder.
      // We can just close the stream.
      return Stream<List<int>>.empty().listen(onData,
          onError: onError, onDone: onDone, cancelOnError: cancelOnError);
    }
  }
}

final List<int> kTransparentImage = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
];

// --- Mock CartService ---

class MockCartService extends ChangeNotifier implements CartService {
  @override
  List<CartItem> get items => [];
  @override
  int get totalItems => 0;
  @override
  double get totalPrice => 0.0;

  @override
  void addToCart(Product product,
      {String? size,
      String? color,
      String? customText,
      String? customColorName,
      int quantity = 1}) {}

  @override
  void clearCart() {}

  @override
  void removeFromCart(String productId, String? size, String? color,
      {String? customText, String? customColorName}) {}

  @override
  void updateQuantity(
      String productId, int quantity, String? size, String? color,
      {String? customText, String? customColorName}) {}
}

void main() {
  late MockCartService mockCartService;
  late GoRouter testRouter;

  // Sample product data for mocking assets/products.json
  final List<Map<String, dynamic>> mockProducts = [
    {
      "id": "test-product-1",
      "collectionId": "test-collection",
      "name": "Test Product 1",
      "price": 20.0,
      "onSale": false,
      "imageUrl": "http://test.com/image1.png",
      "sizes": ["S", "M", "L"],
      "colors": ["Red", "Blue"]
    }
  ];

  // Sample collection data for mocking assets/collections.json
  final List<Map<String, dynamic>> mockCollections = [
    {
      "id": "test-collection",
      "name": "TestCollection",
      "image": "http://test.com/collection.png"
    }
  ];

  setUp(() {
    mockCartService = MockCartService();
    HttpOverrides.global = TestHttpOverrides();
    
    testRouter = GoRouter(
      routes: router.configuration.routes,
      initialLocation: '/',
    );

    // Mock asset loading
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (ByteData? message) async {
      if (message == null) return null;
      final String key = utf8.decode(message.buffer.asUint8List());
      
      if (key.contains('collections.json')) {
         return ByteData.view(
          Uint8List.fromList(utf8.encode(json.encode(mockCollections))).buffer);
      }

      return ByteData.view(
          Uint8List.fromList(utf8.encode(json.encode(mockProducts))).buffer);
    });
  });

  tearDown(() {
    HttpOverrides.global = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', null);
  });

  Widget createTestApp() {
    return ChangeNotifierProvider<CartService>.value(
      value: mockCartService,
      child: MaterialApp.router(
        routerConfig: testRouter,
      ),
    );
  }

  testWidgets('Router starts at Home', (WidgetTester tester) async {
    testRouter.go('/');
    await tester.pumpWidget(createTestApp());
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('Router navigates to About Us', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    testRouter.go('/about');
    await tester.pumpAndSettle();
    expect(find.byType(AboutUsPage), findsOneWidget);
  });

  testWidgets('Router navigates to Collections', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    testRouter.go('/collections');
    await tester.pumpAndSettle();
    expect(find.byType(CollectionsPage), findsOneWidget);
  });

  testWidgets('Router navigates to Sale', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    testRouter.go('/sale');
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(SaleCollectionPage), findsOneWidget);
  });

  testWidgets('Router navigates to Cart', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    testRouter.go('/cart');
    await tester.pumpAndSettle();
    expect(find.byType(CartPage), findsOneWidget);
  });

  testWidgets('Router navigates to Auth', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    testRouter.go('/auth');
    await tester.pumpAndSettle();
    expect(find.byType(AuthPage), findsOneWidget);
  });

  testWidgets('Router navigates to Print Shack', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    testRouter.go('/print-shack');
    await tester.pumpAndSettle();
    expect(find.byType(PrintShackPage), findsOneWidget);
  });

  testWidgets('Router navigates to Print Shack About', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());
    testRouter.go('/print-shack-about');
    await tester.pumpAndSettle();
    expect(find.byType(PrintShackAboutPage), findsOneWidget);
  });
}
