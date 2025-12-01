import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:union_shop/firebase_options.dart';
import 'package:union_shop/models/product_model.dart';
import 'package:union_shop/router.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/services/cart_service.dart';
import 'package:union_shop/services/order_service.dart';
import 'package:union_shop/services/product_service.dart';
import 'package:union_shop/widgets/home_carousel.dart';
import 'package:union_shop/widgets/product_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartService()),
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => OrderService()),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: const UnionShopApp(),
    ),
  );
}

class UnionShopApp extends StatefulWidget {
  const UnionShopApp({super.key});

  @override
  State<UnionShopApp> createState() => _UnionShopAppState();
}

class _UnionShopAppState extends State<UnionShopApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authService = context.read<AuthService>();
    _router = createRouter(authService);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Union Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4d2963)),
      ),
      routerConfig: _router,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  late Future<List<Product>> _productsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productsFuture = _productService.getAllProducts(bundle: DefaultAssetBundle.of(context));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Hero Section
        const HomeCarousel(),

        // Products Section
        Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                const Text(
                  'OUR PRODUCTS!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 48),
                FutureBuilder<List<Product>>(
                  future: _productsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No products found.'));
                    } else {
                      // Display all products
                      final products = snapshot.data!;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 600 ? 2 : 1,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 48,
                          childAspectRatio: 0.8,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return InkWell(
                            onTap: () {
                              context.go('/product/${product.id}');
                            },
                            child: ProductCard(product: product),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),

        // Footer
      ],
    );
  }
}
