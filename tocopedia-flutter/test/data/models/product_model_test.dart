import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tocopedia/data/models/product_model.dart';

void main() {
  final tMap = {
    '_id': 'prod1',
    'owner': {
      '_id': 'user1',
      'name': 'Seller',
      'email': 'seller@example.com',
      '__v': 0,
    },
    'name': 'Test Product',
    'images': ['https://example.com/img1.png', 'https://example.com/img2.png'],
    'price': 50000,
    'stock': 10,
    'SKU': 'SKU-001',
    'description': 'A test product',
    'status': 'active',
    'category': {
      '_id': 'cat1',
      'name': 'Electronics',
      'image': 'https://example.com/cat.png',
      '__v': 0,
    },
    'total_sold': 5,
    'total_rating': 3,
    'average_rating': 4.5,
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-02T00:00:00.000Z',
    '__v': 0,
  };

  group('ProductModel', () {
    test('fromMap should return a valid model', () {
      final result = ProductModel.fromMap(tMap);
      expect(result.id, 'prod1');
      expect(result.name, 'Test Product');
      expect(result.price, 50000);
      expect(result.stock, 10);
      expect(result.sku, 'SKU-001');
      expect(result.description, 'A test product');
      expect(result.status, 'active');
      expect(result.totalSold, 5);
      expect(result.totalRating, 3);
      expect(result.averageRating, 4.5);
      expect(result.v, 0);
    });

    test('fromMap should parse nested owner', () {
      final result = ProductModel.fromMap(tMap);
      expect(result.owner, isNotNull);
      expect(result.owner!.id, 'user1');
      expect(result.owner!.name, 'Seller');
    });

    test('fromMap should parse nested category', () {
      final result = ProductModel.fromMap(tMap);
      expect(result.category, isNotNull);
      expect(result.category!.id, 'cat1');
      expect(result.category!.name, 'Electronics');
    });

    test('fromMap should parse images as List<String>', () {
      final result = ProductModel.fromMap(tMap);
      expect(result.images, isA<List<String>>());
      expect(result.images, hasLength(2));
      expect(result.images![0], 'https://example.com/img1.png');
    });

    test('fromMap should handle null owner and category', () {
      final map = {
        '_id': 'prod1',
        'name': 'Test Product',
        'price': 50000,
        'stock': 10,
        'status': 'active',
        '__v': 0,
      };
      final result = ProductModel.fromMap(map);
      expect(result.owner, isNull);
      expect(result.category, isNull);
      expect(result.images, isNull);
    });

    test('fromMap should convert average_rating to double', () {
      final map = {
        ...tMap,
        'average_rating': 4, // int from API
      };
      final result = ProductModel.fromMap(map);
      expect(result.averageRating, isA<double>());
      expect(result.averageRating, 4.0);
    });

    test('fromJson should decode JSON string', () {
      final jsonString = json.encode(tMap);
      final result = ProductModel.fromJson(jsonString);
      expect(result.id, 'prod1');
      expect(result.name, 'Test Product');
    });

    test('toEntity should return a Product entity', () {
      final model = ProductModel.fromMap(tMap);
      final entity = model.toEntity();
      expect(entity.id, 'prod1');
      expect(entity.name, 'Test Product');
      expect(entity.owner, isNotNull);
      expect(entity.category, isNotNull);
    });

    test('copyWith should create a copy with updated fields', () {
      final model = ProductModel.fromMap(tMap);
      final copy = model.copyWith(name: 'Updated Product', price: 75000);
      expect(copy.name, 'Updated Product');
      expect(copy.price, 75000);
      expect(copy.id, 'prod1');
    });
  });
}
