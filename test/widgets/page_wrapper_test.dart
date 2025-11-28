import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/widgets/app_bar.dart';
import 'package:union_shop/widgets/footer.dart';
import 'package:union_shop/widgets/mobile_menu.dart';
import 'package:union_shop/widgets/page_wrapper.dart';

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

  Widget createTestWidget({required Widget child, bool scrollable = true}) {
    return ChangeNotifierProvider<CartService>.value(
      value: mockCartService,
      child: MaterialApp(
        home: PageWrapper(
          scrollable: scrollable,
          child: child,
        ),
      ),
    );
  }

  testWidgets('PageWrapper displays child content', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(
      child: const Text('Test Content'),
    ));

    expect(find.text('Test Content'), findsOneWidget);
  });

  testWidgets('PageWrapper displays AppBar and Footer', (WidgetTester tester) async {
    await tester.pumpWidget(createTestWidget(
      child: const Text('Test Content'),
    ));

    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.byType(Footer), findsOneWidget);
  });
}
