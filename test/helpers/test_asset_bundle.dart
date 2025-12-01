import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class TestAssetBundle extends CachingAssetBundle {
  final dynamic products;
  final dynamic collections;

  TestAssetBundle({this.products, this.collections});

  @override
  Future<ByteData> load(String key) async {
    if (key == 'assets/products.json') {
      return ByteData.view(Uint8List.fromList(utf8.encode(json.encode(products ?? []))).buffer);
    }
    if (key.contains('collections.json')) {
       return ByteData.view(Uint8List.fromList(utf8.encode(json.encode(collections ?? []))).buffer);
    }
    
    if (key == 'AssetManifest.bin') {
      final manifest = {
        "assets/images/summer/summer_collection.png": [
          {"asset": "assets/images/summer/summer_collection.png"}
        ],
        "assets/images/graduation/graduation_hoodie.png": [
          {"asset": "assets/images/graduation/graduation_hoodie.png"}
        ],
        "assets/images/merchandise/essential_stationary_set.png": [
          {"asset": "assets/images/merchandise/essential_stationary_set.png"}
        ],
        "assets/images/bears/brown_bear.png": [
          {"asset": "assets/images/bears/brown_bear.png"}
        ],
        "assets/images/summer/summer_hat.png": [
          {"asset": "assets/images/summer/summer_hat.png"}
        ],
        "assets/images/summer/cool_summer_tshirt.png": [
          {"asset": "assets/images/summer/cool_summer_tshirt.png"}
        ],
        "assets/images/summer/beach_shorts.png": [
          {"asset": "assets/images/summer/beach_shorts.png"}
        ],
        "assets/images/winter/warm_winter_jacket.png": [
          {"asset": "assets/images/winter/warm_winter_jacket.png"}
        ],
        "assets/images/winter/woolly_scarf.png": [
          {"asset": "assets/images/winter/woolly_scarf.png"}
        ],
        "assets/images/spring/light_spring_jacket.png": [
          {"asset": "assets/images/spring/light_spring_jacket.png"}
        ],
        "assets/images/autumn/cosy_autumn_sweater.png": [
          {"asset": "assets/images/autumn/cosy_autumn_sweater.png"}
        ],
        "assets/images/bears/white_bear.png": [
          {"asset": "assets/images/bears/white_bear.png"}
        ],
        "assets/images/bears/black_bear.png": [
          {"asset": "assets/images/bears/black_bear.png"}
        ],
        "assets/images/merchandise/metal_water_bottle.png": [
          {"asset": "assets/images/merchandise/metal_water_bottle.png"}
        ],
        "assets/images/merchandise/union_lanyard.png": [
          {"asset": "assets/images/merchandise/union_lanyard.png"}
        ],
        "assets/images/merchandise/eco_travel_cup.png": [
          {"asset": "assets/images/merchandise/eco_travel_cup.png"}
        ],
        "assets/images/merchandise/canvas_tote_bag.png": [
          {"asset": "assets/images/merchandise/canvas_tote_bag.png"}
        ],
        "assets/images/graduation/graduation_bear.png": [
          {"asset": "assets/images/graduation/graduation_bear.png"}
        ],
        "assets/images/graduation/certificate_frame.png": [
          {"asset": "assets/images/graduation/certificate_frame.png"}
        ],
        "assets/images/winter/winter_gloves.png": [
          {"asset": "assets/images/winter/winter_gloves.png"}
        ],
        "assets/images/spring/floral_dress.png": [
          {"asset": "assets/images/spring/floral_dress.png"}
        ],
        "assets/images/spring/rain_boots.png": [
          {"asset": "assets/images/spring/rain_boots.png"}
        ],
        "assets/images/autumn/beanie_hat.png": [
          {"asset": "assets/images/autumn/beanie_hat.png"}
        ],
        "assets/images/autumn/corduroy_pants.png": [
          {"asset": "assets/images/autumn/corduroy_pants.png"}
        ],
        "assets/images/winter/winter_collection.png": [
          {"asset": "assets/images/winter/winter_collection.png"}
        ],
        "assets/images/spring/spring_collection.png": [
          {"asset": "assets/images/spring/spring_collection.png"}
        ],
        "assets/images/autumn/autumn_collection.png": [
          {"asset": "assets/images/autumn/autumn_collection.png"}
        ],
      };
      final ByteData? data = const StandardMessageCodec().encodeMessage(manifest);
      return data!;
    }

    if (key == 'AssetManifest.json') {
      final manifest = {
        "assets/images/summer/summer_collection.png": ["assets/images/summer/summer_collection.png"],
        "assets/images/graduation/graduation_hoodie.png": ["assets/images/graduation/graduation_hoodie.png"],
        "assets/images/merchandise/essential_stationary_set.png": ["assets/images/merchandise/essential_stationary_set.png"],
        "assets/images/bears/brown_bear.png": ["assets/images/bears/brown_bear.png"],
        "assets/images/summer/summer_hat.png": ["assets/images/summer/summer_hat.png"]
      };
      return ByteData.view(Uint8List.fromList(utf8.encode(json.encode(manifest))).buffer);
    }

    if (key.endsWith('.png') || key.endsWith('.jpg')) {
      return ByteData.view(Uint8List.fromList(kTransparentImage).buffer);
    }

    throw FlutterError('Unable to load asset: $key');
  }
}

const List<int> kTransparentImage = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
];
