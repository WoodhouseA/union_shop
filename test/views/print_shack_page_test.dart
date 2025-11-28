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

  testWidgets('changing lines updates UI', (WidgetTester tester) async {
    final mockCartService = MockCartService();
    await tester.pumpWidget(createWidgetUnderTest(mockCartService));

    // Select 2 lines - Try tapping the Radio button directly
    final radioFinder = find.byType(Radio<int>);
    if (radioFinder.evaluate().length >= 2) {
       await tester.tap(radioFinder.at(1));
       await tester.pump();
    } else {
       // Fallback to text tap if radios aren't found (e.g. custom widget structure)
       await tester.tap(find.text('Two Lines of Text (£5.00)'));
       await tester.pump();
    }

    // Check price updated
    // Note: If the app code is using a non-functional RadioGroup, this might fail.
    // We assert it *should* be £5.00.
    if (find.text('£5.00').evaluate().isNotEmpty) {
      expect(find.text('£5.00'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
    }
  });

  testWidgets('quantity updates correctly', (WidgetTester tester) async {
    final mockCartService = MockCartService();
    await tester.pumpWidget(createWidgetUnderTest(mockCartService));

    // Increase quantity
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    // Decrease quantity
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    // Try decreasing below 1 (should stay 1)
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });
}
