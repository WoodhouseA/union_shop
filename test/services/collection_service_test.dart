import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/services/collection_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CollectionService collectionService;

  final mockCollections = [
    {
      "id": "summer",
      "name": "Summer Collection",
      "image": "assets/images/summer.png"
    },
    {
      "id": "winter",
      "name": "Winter Collection",
      "image": "assets/images/winter.png"
    }
  ];

  setUp(() {
    collectionService = CollectionService();

    // Mock the asset loading
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
      'flutter/assets',
      (ByteData? message) async {
        final String jsonStr = json.encode(mockCollections);
        final Uint8List utf8Bytes = utf8.encode(jsonStr);
        return ByteData.view(utf8Bytes.buffer);
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler(
      'flutter/assets',
      null,
    );
  });

  test('getAllCollections returns all collections', () async {
    final collections = await collectionService.getAllCollections();
    expect(collections.length, 2);
    expect(collections[0]['name'], 'Summer Collection');
    expect(collections[1]['id'], 'winter');
  });
}
