import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:union_shop/models/cart_model.dart';
import 'package:union_shop/models/order_model.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/services/order_service.dart';
import 'package:union_shop/views/account_dashboard_page.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// --- Mock AuthService ---

class MockAuthService extends ChangeNotifier implements AuthService {
  User? _currentUser;

  MockAuthService({User? currentUser}) : _currentUser = currentUser;

  @override
  User? get currentUser => _currentUser;

  @override
  Stream<User?> get authStateChanges => Stream.value(_currentUser);

  @override
  Future<User?> signIn(String email, String password) async {
    return null;
  }

  @override
  Future<User?> signUp(String email, String password) async {
    return null;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    notifyListeners();
  }
}

// --- Mock OrderService ---
class MockOrderService extends ChangeNotifier implements OrderService {
  final List<OrderModel> _orders;

  MockOrderService({List<OrderModel> orders = const []}) : _orders = orders;

  @override
  Future<void> placeOrder(String userId, List<CartItem> items, double totalPrice) async {}

  @override
  Stream<List<OrderModel>> getUserOrders(String userId) {
    return Stream.value(_orders);
  }
}

// --- Mock User ---
class MockUser extends Fake implements User {
  final String _email;
  final String _uid;
  MockUser(this._email, this._uid);

  @override
  String? get email => _email;
  
  @override
  String get uid => _uid;
}

void main() {
  testWidgets('AccountDashboardPage shows "Not logged in" when no user', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>(
            create: (_) => MockAuthService(currentUser: null),
          ),
          ChangeNotifierProvider<OrderService>(
            create: (_) => MockOrderService(),
          ),
        ],
        child: const MaterialApp(
          home: AccountDashboardPage(),
        ),
      ),
    );

    expect(find.text('Not logged in'), findsOneWidget);
  });

  testWidgets('AccountDashboardPage shows user email and orders when logged in', (WidgetTester tester) async {
    final mockUser = MockUser('test@example.com', 'user1');
    
    final testProduct = Product(
      id: '1',
      collectionId: 'col1',
      name: 'Test Product',
      price: 5.0,
      onSale: false,
      imageUrl: 'http://example.com/image.jpg',
      sizes: ['S'],
      colors: ['Red'],
    );

    final testItem = CartItem(
      product: testProduct,
      quantity: 2,
      size: 'S',
      color: 'Red',
    );
    
    final testOrder = OrderModel(
      id: 'order123',
      userId: 'user1',
      items: [testItem],
      totalPrice: 20.0,
      date: DateTime.now(),
      status: 'Pending',
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>(
            create: (_) => MockAuthService(currentUser: mockUser),
          ),
          ChangeNotifierProvider<OrderService>(
            create: (_) => MockOrderService(orders: [testOrder]),
          ),
        ],
        child: const MaterialApp(
          home: AccountDashboardPage(),
        ),
      ),
    );

    // Allow stream builder to build
    await tester.pump();

    expect(find.text('Welcome, test@example.com'), findsOneWidget);
    expect(find.text('Order History'), findsOneWidget);
    expect(find.text('Order #order123'), findsOneWidget);
    expect(find.text('£20.00'), findsOneWidget);
    expect(find.text('Status: Pending'), findsOneWidget);
    expect(find.text('2x Test Product'), findsOneWidget);
    expect(find.text('£10.00'), findsOneWidget);
    
    expect(find.text('Saved Addresses'), findsOneWidget);
    expect(find.text('Sign Out'), findsOneWidget);
  });
  
  testWidgets('AccountDashboardPage shows "No orders yet" when list is empty', (WidgetTester tester) async {
    final mockUser = MockUser('test@example.com', 'user1');
    
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>(
            create: (_) => MockAuthService(currentUser: mockUser),
          ),
          ChangeNotifierProvider<OrderService>(
            create: (_) => MockOrderService(orders: []),
          ),
        ],
        child: const MaterialApp(
          home: AccountDashboardPage(),
        ),
      ),
    );

    // Allow stream builder to build
    await tester.pump();

    expect(find.text('No orders yet.'), findsOneWidget);
  });
}
