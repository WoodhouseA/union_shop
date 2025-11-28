import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/main.dart';
import 'package:union_shop/views/about_us_page.dart';
import 'package:union_shop/views/auth_page.dart';
import 'package:union_shop/views/cart_page.dart';
import 'package:union_shop/views/collection_page.dart';
import 'package:union_shop/views/collections_page.dart';
import 'package:union_shop/views/print_shack_about_page.dart';
import 'package:union_shop/views/print_shack_page.dart';
import 'package:union_shop/views/product_page.dart';
import 'package:union_shop/views/sale_collection_page.dart';
import 'package:union_shop/widgets/page_wrapper.dart';

final GoRouter router = GoRouter(
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
            return const PageWrapper(scrollable: false, child: CartPage());
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
      ],
    ),
  ],
);
