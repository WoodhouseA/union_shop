import 'dart:convert';
import 'package:flutter/services.dart';

class CollectionService {
  Future<List<Map<String, dynamic>>> getAllCollections() async {
    final String jsonString =
        await rootBundle.loadString('assets/collections.json');
    final List<dynamic> jsonResponse = json.decode(jsonString);
    return jsonResponse.cast<Map<String, dynamic>>();
  }
}
