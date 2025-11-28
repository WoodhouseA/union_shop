import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/widgets/app_bar.dart';

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
  });

  Widget createTestWidget({required Widget child}) {
    return ChangeNotifierProvider<CartService>.value(
      value: mockCartService,
      child: MaterialApp(
        home: Scaffold(
          appBar: child as PreferredSizeWidget,
        ),
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
}
