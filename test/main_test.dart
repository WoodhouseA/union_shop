import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/order_model.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/services/order_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'helpers/test_asset_bundle.dart';

// --- Mock AuthService ---

class MockAuthService extends ChangeNotifier implements AuthService {
  @override
  User? get currentUser => null;

  @override
  Stream<User?> get authStateChanges => Stream.value(null);

  @override
  Future<User?> signIn(String email, String password) async {
    return null;
  }

  @override
  Future<User?> signUp(String email, String password) async {
    return null;
  }

  @override
  Future<void> signOut() async {}
}

// --- Mock OrderService ---
class MockOrderService extends ChangeNotifier implements OrderService {
  @override
  Future<void> placeOrder(String userId, List<CartItem> items, double totalPrice) async {}

  @override
  Stream<List<OrderModel>> getUserOrders(String userId) {
    return Stream.value([]);
  }
}

void main() {
  final mockProducts = [
    {
      "id": "prod-001",
      "collectionId": "summer",
      "name": "Test Product 1",
      "price": 20.0,
      "onSale": false,
      "salePrice": null,
      "imageUrl": "https://example.com/img1.jpg",
      "sizes": ["S"],
      "colors": ["Red"]
    },
    {
      "id": "prod-002",
      "collectionId": "winter",
      "name": "Test Product 2",
      "price": 30.0,
      "onSale": true,
      "salePrice": 25.0,
      "imageUrl": "https://example.com/img2.jpg",
      "sizes": ["M"],
      "colors": ["Blue"]
    }
  ];

  setUp(() {
    rootBundle.evict('assets/products.json');
    HttpOverrides.global = TestHttpOverrides();
  });

  tearDown(() {
    HttpOverrides.global = null;
  });

  Widget createWidgetUnderTest() {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: SingleChildScrollView(
              child: HomeScreen(),
            ),
          ),
        ),
        GoRoute(
          path: '/sale',
          builder: (context, state) => const Scaffold(body: Text('Sale Page')),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) => Scaffold(body: Text('Product ${state.pathParameters['id']}')),
        ),
      ],
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider<AuthService>(create: (_) => MockAuthService()),
        ChangeNotifierProvider<OrderService>(create: (_) => MockOrderService()),
      ],
      child: DefaultAssetBundle(
        bundle: TestAssetBundle(products: mockProducts),
        child: MaterialApp.router(
          routerConfig: router,
        ),
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
    } catch (e) {
      // Ignore
    }
  }

  testWidgets('HomeScreen displays hero section and products', (WidgetTester tester) async {
    // Set surface size to ensure grid items fit (desktop size)
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createWidgetUnderTest());
    await waitForLoad(tester);

    // Check Hero Section
    expect(find.text('CHECK OUT THE SALE!'), findsOneWidget); // Title
    expect(find.text('GO TO SALE'), findsOneWidget); // Button
    expect(find.text("Don't miss out on our exclusive sale items!"), findsOneWidget);

    // Check Products Section
    expect(find.text('OUR PRODUCTS!'), findsOneWidget);
    expect(find.text('Test Product 1'), findsOneWidget);
    expect(find.text('Test Product 2'), findsOneWidget);
  });

  testWidgets('HomeScreen navigates to sale page', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await waitForLoad(tester);

    final saleButton = find.widgetWithText(ElevatedButton, 'GO TO SALE');
    await tester.ensureVisible(saleButton);
    await tester.tap(saleButton);
    await tester.pumpAndSettle();

    expect(find.text('Sale Page'), findsOneWidget);
  });

  testWidgets('HomeScreen navigates to product page', (WidgetTester tester) async {
    // Set surface size to ensure grid items fit
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(createWidgetUnderTest());
    await waitForLoad(tester);

    final productCard = find.text('Test Product 1');
    await tester.ensureVisible(productCard);
    await tester.tap(productCard);
    await tester.pumpAndSettle();

    expect(find.text('Product prod-001'), findsOneWidget);
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