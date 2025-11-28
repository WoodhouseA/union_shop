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


}
