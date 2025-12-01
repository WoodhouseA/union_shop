import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/services/auth_service.dart';
import 'package:union_shop/views/about_us_page.dart';
import 'package:union_shop/views/account_dashboard_page.dart';
import 'package:union_shop/views/auth_page.dart';
import 'package:union_shop/views/cart_page.dart';
import 'package:union_shop/views/collection_page.dart';
import 'package:union_shop/views/collections_page.dart';
import 'package:union_shop/views/print_shack_about_page.dart';
import 'package:union_shop/views/print_shack_page.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/views/sale_collection_page.dart';
import 'package:union_shop/views/search_results_page.dart';
import 'package:union_shop/widgets/page_wrapper.dart';

GoRouter createRouter(AuthService authService) {
  return GoRouter(
    refreshListenable: authService,
    redirect: (context, state) {
      final isLoggedIn = authService.currentUser != null;
      final isLoggingIn = state.uri.path == '/auth';

      if (!isLoggedIn && state.uri.path == '/account') {
        return '/auth';
      }

      if (isLoggedIn && isLoggingIn) {
        return '/account';
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const PageWrapper(child: HomeScreen());
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'about',
            builder: (BuildContext context, GoRouterState state) {
              return const PageWrapper(child: AboutUsPage());
            },
          ),
          GoRoute(
            path: 'collections',
            builder: (BuildContext context, GoRouterState state) {
              return const PageWrapper(child: CollectionsPage());
            },
          ),
          GoRoute(
            path: 'collection/:id',
            builder: (BuildContext context, GoRouterState state) {
              final String id = state.pathParameters['id']!;
              final String name = state.uri.queryParameters['name'] ?? 'Collection';
              return PageWrapper(
                child: CollectionPage(
                  collectionId: id,
                  collectionName: name,
                ),
              );
            },
          ),
          GoRoute(
            path: 'product/:id',
            builder: (BuildContext context, GoRouterState state) {
              final String id = state.pathParameters['id']!;
              return PageWrapper(
                child: ProductPage(
                  productId: id,
                ),
              );
            },
          ),
          GoRoute(
            path: 'cart',
            builder: (BuildContext context, GoRouterState state) {
              return const PageWrapper(child: CartPage());
            },
          ),
          GoRoute(
            path: 'sale',
            builder: (BuildContext context, GoRouterState state) {
              return const PageWrapper(child: SaleCollectionPage());
            },
          ),
          GoRoute(
            path: 'auth',
            builder: (BuildContext context, GoRouterState state) {
              return const PageWrapper(child: AuthPage());
            },
          ),
          GoRoute(
            path: 'account',
            builder: (BuildContext context, GoRouterState state) {
              return const PageWrapper(child: AccountDashboardPage());
            },
          ),
          GoRoute(
            path: 'print-shack',
            builder: (BuildContext context, GoRouterState state) {
              return const PageWrapper(child: PrintShackPage());
            },
          ),
          GoRoute(
            path: 'print-shack-about',
            builder: (BuildContext context, GoRouterState state) {
              return const PageWrapper(child: PrintShackAboutPage());
            },
          ),
          GoRoute(
            path: 'search',
            builder: (BuildContext context, GoRouterState state) {
              final query = state.uri.queryParameters['q'] ?? '';
              return PageWrapper(child: SearchResultsPage(initialQuery: query));
            },
          ),
        ],
      ),
    ],
  );
}
