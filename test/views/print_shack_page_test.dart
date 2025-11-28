import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/views/print_shack_page.dart';

class MockCartService extends CartService {
  Product? lastAddedProduct;
  int? lastQuantity;
  String? lastCustomText;

  @override
  void addToCart(Product product,
      {String? size,
      String? color,
      String? customText,
      String? customColorName,
      int quantity = 1}) {
    lastAddedProduct = product;
    lastQuantity = quantity;
    lastCustomText = customText;
  }
}

void main() {
  Widget createWidgetUnderTest(CartService cartService) {
    return ChangeNotifierProvider<CartService>.value(
      value: cartService,
      child: const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PrintShackPage(),
          ),
        ),
      ),
    );
  }

  testWidgets('initial state is correct', (WidgetTester tester) async {
    final mockCartService = MockCartService();
    await tester.pumpWidget(createWidgetUnderTest(mockCartService));

    // Check price
    expect(find.text('£3.00'), findsOneWidget);
    
    // Check text fields (only 1 visible)
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Line 1 Text'), findsOneWidget);
    expect(find.text('Line 2 Text'), findsNothing);

    // Check quantity
    expect(find.text('1'), findsOneWidget);
  });
}
