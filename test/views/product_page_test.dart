import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/services/product_service.dart';
import 'package:union_shop/views/product_page.dart';

class MockCartService extends CartService {
  Product? lastAddedProduct;
  int totalQuantityAdded = 0;
  String? lastSize;
  String? lastColor;

  @override
  void addToCart(Product product,
      {String? size,
      String? color,
      String? customText,
      String? customColorName,
      int quantity = 1}) {
    lastAddedProduct = product;
    totalQuantityAdded += quantity;
    lastSize = size;
    lastColor = color;
    notifyListeners();
  }
}

void main() {
  final mockProducts = [
    {
      "id": "prod-001",
      "collectionId": "summer",
      "name": "Cool Summer T-Shirt",
      "price": 19.99,
      "onSale": true,
      "salePrice": 14.99,
      "imageUrl": "https://picsum.photos/seed/prod-001/400/300",
      "sizes": ["S", "M", "L", "XL"],
      "colors": ["Red", "Blue", "Green"]
    }
  ];

  setUp(() {
    rootBundle.evict('assets/products.json');
    HttpOverrides.global = TestHttpOverrides();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (ByteData? message) async {
        if (message == null) return null;
        final key = utf8.decode(message.buffer.asUint8List(message.offsetInBytes, message.lengthInBytes));
        
        if (key == 'assets/products.json') {
          final String jsonStr = json.encode(mockProducts);
          final Uint8List encoded = utf8.encode(jsonStr);
          return ByteData.view(encoded.buffer);
        }
        return null;
      },
    );
  });

  tearDown(() async {
    HttpOverrides.global = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      null,
    );
  });

  Widget createWidgetUnderTest(String productId, CartService cartService) {
    return ChangeNotifierProvider<CartService>.value(
      value: cartService,
      child: MaterialApp(
        home: Scaffold(
          body: ProductPage(
            key: ValueKey(productId),
            productId: productId,
          ),
        ),
      ),
    );
  }

  test('Verify JSON parsing', () {
    final jsonStr = json.encode(mockProducts);
    final List<dynamic> jsonResponse = json.decode(jsonStr);
    final products = jsonResponse.map((data) => Product.fromJson(data)).toList();
    expect(products.length, 1);
    expect(products.first.id, 'prod-001');
  });

  test('Verify ProductService logic with mock bundle', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (ByteData? message) async {
      final String key = utf8.decode(message!.buffer.asUint8List());
      if (key == 'assets/products.json') {
        final Uint8List encoded = utf8.encode(json.encode(mockProducts));
        return ByteData.view(encoded.buffer);
      }
      return null;
    });

    final service = ProductService();
    final product = await service.getProductById('prod-001');
    expect(product.id, 'prod-001');
  });

  testWidgets('ProductPage tests', (WidgetTester tester) async {
    final mockCartService = MockCartService();

    // Clear cache to ensure widget triggers a new load
    rootBundle.evict('assets/products.json');

    // --- Test 1: Load details ---
    await tester.pumpWidget(createWidgetUnderTest('prod-001', mockCartService));
    await tester.pumpAndSettle();

    // Check name
    expect(find.text('Cool Summer T-Shirt'), findsOneWidget);
    
    // Check prices (Sale)
    expect(find.textContaining('19.99'), findsOneWidget); // Original
    expect(find.textContaining('14.99'), findsOneWidget); // Sale
      
    // Check dropdowns exist
    expect(find.text('Size'), findsOneWidget);
    expect(find.text('Color'), findsOneWidget);
    
    // Check initial selection (S and Red based on JSON order)
    expect(find.text('S'), findsOneWidget);
    expect(find.text('Red'), findsOneWidget);

    // --- Test 2: Add to cart ---
    // Ensure Add button is visible
    final addButton = find.byIcon(Icons.add);
    await tester.ensureVisible(addButton);
    await tester.pumpAndSettle();

    // Change Quantity to 2
    await tester.tap(addButton);
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    // Change Size to M
    final sizeDropdown = find.text('S');
    await tester.ensureVisible(sizeDropdown);
    await tester.tap(sizeDropdown); // Open dropdown
    await tester.pumpAndSettle();
    await tester.tap(find.text('M').last); // Select M
    await tester.pumpAndSettle();

    // Change Color to Blue
    final colorDropdown = find.text('Red');
    await tester.ensureVisible(colorDropdown);
    await tester.tap(colorDropdown); // Open dropdown
    await tester.pumpAndSettle();
    await tester.tap(find.text('Blue').last); // Select Blue
    await tester.pumpAndSettle();

    // Add to Cart
    final addToCartButton = find.text('ADD TO CART');
    await tester.ensureVisible(addToCartButton);
    await tester.tap(addToCartButton);
    await tester.pump();

    // Verify
    expect(find.text('Added 2 Cool Summer T-Shirt(s) to cart'), findsOneWidget);
    expect(mockCartService.lastAddedProduct!.id, 'prod-001');
    expect(mockCartService.totalQuantityAdded, 2);
    expect(mockCartService.lastSize, 'M');
    expect(mockCartService.lastColor, 'Blue');
  });
}

// Mock HTTP classes for NetworkImage
class TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _MockHttpClient();
  }
}

class _MockHttpClient implements HttpClient {
  @override
  bool autoUncompress = true;

  @override
  Future<HttpClientRequest> getUrl(Uri url) async {
    return _MockHttpClientRequest();
  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }
}

class _MockHttpClientRequest implements HttpClientRequest {
  @override
  final HttpHeaders headers = _MockHttpHeaders();

  @override
  Future<HttpClientResponse> close() async {
    return _MockHttpClientResponse();
  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }
}

class _MockHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => kTransparentImage.length;
  
  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData, {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.fromIterable([kTransparentImage]).listen(onData, onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
  
  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }
}

class _MockHttpHeaders implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnimplementedError();
  }
}

const List<int> kTransparentImage = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
];
