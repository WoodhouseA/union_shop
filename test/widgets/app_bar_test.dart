import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/widgets/app_bar.dart';

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

class _MockHttpHeaders extends Fake implements HttpHeaders {
  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {}
}

class _MockHttpClientResponse extends Fake implements HttpClientResponse {
  @override
  int get statusCode => 404;

  @override
  int get contentLength => 0;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return const Stream<List<int>>.empty().listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }
}

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

  setUp(() {
    mockCartService = MockCartService();
    HttpOverrides.global = TestHttpOverrides();
  });

  tearDown(() {
    HttpOverrides.global = null;
  });

  Widget createTestWidget({required Widget child}) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            appBar: child as PreferredSizeWidget,
            body: Container(),
          ),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => Scaffold(
            body: Text('Search Page: ${state.uri.queryParameters['q'] ?? ''}'),
          ),
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) => const Scaffold(body: Text('Auth Page')),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const Scaffold(body: Text('Cart Page')),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const Scaffold(body: Text('About Page')),
        ),
        GoRoute(
          path: '/collections',
          builder: (context, state) => const Scaffold(body: Text('Collections Page')),
        ),
        GoRoute(
          path: '/sale',
          builder: (context, state) => const Scaffold(body: Text('Sale Page')),
        ),
        GoRoute(
          path: '/print-shack',
          builder: (context, state) => const Scaffold(body: Text('Print Shack Page')),
        ),
        GoRoute(
          path: '/print-shack-about',
          builder: (context, state) => const Scaffold(body: Text('Print Shack About Page')),
        ),
      ],
    );

    return ChangeNotifierProvider<CartService>.value(
      value: mockCartService,
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  testWidgets('CustomAppBar displays title and logo', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(
      child: CustomAppBar(onMenuPressed: () {}),
    ));

    expect(find.text('UNIVERSITY OF PORTSMOUTH SHOP'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('CustomAppBar displays action buttons', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(
      child: CustomAppBar(onMenuPressed: () {}),
    ));

    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.person_outline), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsOneWidget);
  });

  testWidgets('CustomAppBar displays menu button on mobile', (WidgetTester tester) async {
    // Set screen size to mobile
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget(
      child: CustomAppBar(onMenuPressed: () {}),
    ));

    expect(find.byIcon(Icons.menu), findsOneWidget);

    // Reset screen size
    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('CustomAppBar hides menu button on desktop', (WidgetTester tester) async {
    // Set screen size to desktop
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget(
      child: CustomAppBar(onMenuPressed: () {}),
    ));

    expect(find.byIcon(Icons.menu), findsNothing);

    // Reset screen size
    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('CustomAppBar displays nav items on desktop', (WidgetTester tester) async {
    // Set screen size to desktop
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget(
      child: CustomAppBar(onMenuPressed: () {}),
    ));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('About Us'), findsOneWidget);
    expect(find.text('Collections'), findsOneWidget);
    expect(find.text('The Print Shack'), findsOneWidget);
    expect(find.text('Sale!'), findsOneWidget);

    // Reset screen size
    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('Menu button callback is triggered', (WidgetTester tester) async {
    bool menuPressed = false;
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget(
      child: CustomAppBar(onMenuPressed: () {
        menuPressed = true;
      }),
    ));

    await tester.tap(find.byIcon(Icons.menu));
    expect(menuPressed, isTrue);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('Search field is visible on desktop', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget(
      child: CustomAppBar(onMenuPressed: () {}),
    ));

    expect(find.byType(TextField), findsOneWidget);
    
    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('Search field is hidden on mobile', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget(
      child: CustomAppBar(onMenuPressed: () {}),
    ));

    expect(find.byType(TextField), findsNothing);
    // Should find the search icon button instead
    expect(find.widgetWithIcon(IconButton, Icons.search), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('Submitting search navigates to search page with query', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget(
      child: CustomAppBar(onMenuPressed: () {}),
    ));

    await tester.enterText(find.byType(TextField), 'hoodie');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.text('Search Page: hoodie'), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });

  testWidgets('Tapping search icon on mobile navigates to search page', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(createTestWidget(
      child: CustomAppBar(onMenuPressed: () {}),
    ));

    await tester.tap(find.widgetWithIcon(IconButton, Icons.search));
    await tester.pumpAndSettle();

    expect(find.text('Search Page: '), findsOneWidget);

    addTearDown(tester.view.resetPhysicalSize);
  });
}
