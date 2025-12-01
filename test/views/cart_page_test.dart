import 'dart:async';
import 'dart:io';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/order_model.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/services/order_service.dart';
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

class FakeUser extends Fake implements User {
  @override
  final String uid;
  @override
  final String? email;

  FakeUser({required this.uid, this.email});
}

class MockAuthService extends ChangeNotifier implements AuthService {
  User? _user;
  @override
  User? get currentUser => _user;

  @override
  Stream<User?> get authStateChanges => Stream.value(_user);

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }
  
  @override
  Future<User?> signIn(String email, String password) async => _user;
  
  @override
  Future<User?> signUp(String email, String password) async => _user;
  
  @override
  Future<void> signOut() async {
    _user = null;
    notifyListeners();
  }
}

class MockOrderService extends ChangeNotifier implements OrderService {
  bool placeOrderCalled = false;

  @override
  Future<void> placeOrder(
      String userId, List<CartItem> items, double totalPrice) async {
    placeOrderCalled = true;
    notifyListeners();
  }

  @override
  Stream<List<OrderModel>> getUserOrders(String userId) {
    return Stream.value([]);
  }
}

class MockCartService extends CartService {
  MockCartService()
      : super(
          auth: MockFirebaseAuth(),
          firestore: FakeFirebaseFirestore(),
        );

  final List<CartItem> _mockItems = [];

  @override
  List<CartItem> get items => _mockItems;

  @override
  double get totalPrice => _mockItems.fold(
      0.0, (total, item) => total + (item.product.price * item.quantity));

  @override
  void addToCart(Product product,
      {String? size,
      String? color,
      String? customText,
      String? customColorName,
      int quantity = 1}) {
    _mockItems.add(CartItem(
        product: product,
        quantity: quantity,
        size: size,
        color: color,
        customText: customText,
        customColorName: customColorName));
    notifyListeners();
  }

  @override
  void updateQuantity(
      String productId, int quantity, String? size, String? color,
      {String? customText, String? customColorName}) {
    final index =
        _mockItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (quantity > 0) {
        _mockItems[index].quantity = quantity;
      } else {
        _mockItems.removeAt(index);
      }
      notifyListeners();
    }
  }

  @override
  void removeFromCart(String productId, String? size, String? color,
      {String? customText, String? customColorName}) {
    _mockItems.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  @override
  void clearCart() {
    _mockItems.clear();
    notifyListeners();
  }
}

void main() {
  setUpAll(() {
    HttpOverrides.global = TestHttpOverrides();
  });

  Widget createWidgetUnderTest({
    required CartService cartService,
    required AuthService authService,
    required OrderService orderService,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartService>.value(value: cartService),
        ChangeNotifierProvider<AuthService>.value(value: authService),
        ChangeNotifierProvider<OrderService>.value(value: orderService),
      ],
      child: MaterialApp(
        home: const Scaffold(body: CartPage()),
        onGenerateRoute: (settings) {
          if (settings.name == '/auth') {
            return MaterialPageRoute(
                builder: (_) => const Scaffold(body: Text('Auth Page')));
          }
          if (settings.name == '/account') {
            return MaterialPageRoute(
                builder: (_) => const Scaffold(body: Text('Account Page')));
          }
          return null;
        },
      ),
    );
  }

  testWidgets('CartPage displays empty message when cart is empty',
      (WidgetTester tester) async {
    final cartService = MockCartService();
    final authService = MockAuthService();
    final orderService = MockOrderService();

    await tester.pumpWidget(createWidgetUnderTest(
      cartService: cartService,
      authService: authService,
      orderService: orderService,
    ));

    expect(find.text('Your cart is empty.'), findsOneWidget);
  });

  testWidgets('CartPage displays items and total', (WidgetTester tester) async {
    final cartService = MockCartService();
    final authService = MockAuthService();
    final orderService = MockOrderService();
    
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

    await tester.pumpWidget(createWidgetUnderTest(
      cartService: cartService,
      authService: authService,
      orderService: orderService,
    ));

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
    final cartService = MockCartService();
    final authService = MockAuthService();
    final orderService = MockOrderService();
    
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

    await tester.pumpWidget(createWidgetUnderTest(
      cartService: cartService,
      authService: authService,
      orderService: orderService,
    ));

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

  testWidgets('CartPage redirects to auth if not logged in on checkout',
      (WidgetTester tester) async {
    final cartService = MockCartService();
    final authService = MockAuthService(); // Not logged in
    final orderService = MockOrderService();
    
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

    // Use GoRouter for this test to handle redirection properly
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: CartPage()),
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) => const Scaffold(body: Text('Auth Page')),
        ),
      ],
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CartService>.value(value: cartService),
          ChangeNotifierProvider<AuthService>.value(value: authService),
          ChangeNotifierProvider<OrderService>.value(value: orderService),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Please login to checkout.'), findsOneWidget);
    expect(find.text('Auth Page'), findsOneWidget);
  });

  testWidgets('CartPage places order if logged in', (WidgetTester tester) async {
    final cartService = MockCartService();
    final authService = MockAuthService();
    final orderService = MockOrderService();
    
    authService.setUser(FakeUser(uid: 'user1', email: 'test@test.com'));

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

    // Use GoRouter for this test
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: CartPage()),
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) => const Scaffold(body: Text('Account Page')),
        ),
      ],
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<CartService>.value(value: cartService),
          ChangeNotifierProvider<AuthService>.value(value: authService),
          ChangeNotifierProvider<OrderService>.value(value: orderService),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Checkout'));
    await tester.pump(); // Start loading
    await tester.pump(); // Finish async
    await tester.pumpAndSettle(); // Dialog

    expect(orderService.placeOrderCalled, true);
    expect(cartService.items.isEmpty, true);
    
    expect(find.text('Order Placed'), findsOneWidget);
    
    await tester.tap(find.text('View Orders'));
    await tester.pumpAndSettle();
    
    expect(find.text('Account Page'), findsOneWidget);
  });
}

