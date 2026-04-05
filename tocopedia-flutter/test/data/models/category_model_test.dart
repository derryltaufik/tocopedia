import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tocopedia/data/models/category_model.dart';

void main() {
  const tMap = {
    '_id': 'cat1',
    'name': 'Electronics',
    'image': 'https://example.com/cat.png',
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-02T00:00:00.000Z',
    '__v': 0,
  };

  const tModel = CategoryModel(
    id: 'cat1',
    name: 'Electronics',
    image: 'https://example.com/cat.png',
    createdAt: null,
    updatedAt: null,
    v: 0,
  );

  group('CategoryModel', () {
    test('fromMap should return a valid model', () {
      final result = CategoryModel.fromMap(tMap);
      expect(result.id, 'cat1');
      expect(result.name, 'Electronics');
      expect(result.image, 'https://example.com/cat.png');
      expect(result.v, 0);
      expect(result.createdAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
      expect(result.updatedAt, DateTime.parse('2024-01-02T00:00:00.000Z'));
    });

    test('fromMap should handle null timestamps', () {
      final map = {
        '_id': 'cat1',
        'name': 'Electronics',
        'image': 'https://example.com/cat.png',
        '__v': 0,
      };
      final result = CategoryModel.fromMap(map);
      expect(result.createdAt, isNull);
      expect(result.updatedAt, isNull);
    });

    test('toMap should return a valid map', () {
      final result = tModel.toMap();
      expect(result['_id'], 'cat1');
      expect(result['name'], 'Electronics');
      expect(result['image'], 'https://example.com/cat.png');
      expect(result['__v'], 0);
    });

    test('fromJson should decode JSON string', () {
      final jsonString = json.encode(tMap);
      final result = CategoryModel.fromJson(jsonString);
      expect(result.id, 'cat1');
      expect(result.name, 'Electronics');
    });

    test('toJson should encode to JSON string', () {
      final jsonString = tModel.toJson();
      final decoded = json.decode(jsonString);
      expect(decoded['_id'], 'cat1');
      expect(decoded['name'], 'Electronics');
    });

    test('toEntity should return a Category entity', () {
      final entity = tModel.toEntity();
      expect(entity.id, 'cat1');
      expect(entity.name, 'Electronics');
      expect(entity.image, 'https://example.com/cat.png');
    });

    test('fromEntity should create model from entity', () {
      final entity = tModel.toEntity();
      final model = CategoryModel.fromEntity(entity);
      expect(model.id, 'cat1');
      expect(model.name, 'Electronics');
    });

    test('copyWith should create a copy with updated fields', () {
      final copy = tModel.copyWith(name: 'Fashion');
      expect(copy.name, 'Fashion');
      expect(copy.id, 'cat1');
    });

    test('equality should work correctly', () {
      const model2 = CategoryModel(
        id: 'cat1',
        name: 'Electronics',
        image: 'https://example.com/cat.png',
        createdAt: null,
        updatedAt: null,
        v: 0,
      );
      expect(tModel, equals(model2));
    });
  });
}
