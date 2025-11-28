import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:union_shop/services/collection_service.dart';
import 'package:union_shop/views/collections_page.dart';

// Mock CollectionService
class MockCollectionService extends CollectionService {
  final List<Map<String, dynamic>> mockCollections;
  final bool shouldFail;

  MockCollectionService({this.mockCollections = const [], this.shouldFail = false});

  @override
  Future<List<Map<String, dynamic>>> getAllCollections() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (shouldFail) {
      throw Exception('Failed to load collections');
    }
    return mockCollections;
  }
}

void main() {
  final testCollections = [
    {
      'id': 'col1',
      'name': 'Collection 1',
      'image': 'http://example.com/1.jpg',
    },
    {
      'id': 'col2',
      'name': 'Collection 2',
      'image': 'http://example.com/2.jpg',
    },
  ];

  Widget createWidgetUnderTest(CollectionService collectionService) {
    final router = GoRouter(
      initialLocation: '/collections',
      routes: [
        GoRoute(
          path: '/collections',
          builder: (context, state) => Scaffold(
            body: SingleChildScrollView(
              child: CollectionsPage(
                collectionService: collectionService,
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/collection/:id',
          builder: (context, state) => Scaffold(
            body: Text('Collection ${state.pathParameters['id']}'),
          ),
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: router,
    );
  }
}
