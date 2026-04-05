import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tocopedia/data/models/user_model.dart';

void main() {
  const tMap = {
    '_id': 'user1',
    'name': 'John',
    'email': 'john@example.com',
    'password': 'hashed_password',
    'token': 'jwt_token',
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-02T00:00:00.000Z',
    '__v': 0,
  };

  group('UserModel', () {
    test('fromMap should return a valid model', () {
      final result = UserModel.fromMap(tMap);
      expect(result.id, 'user1');
      expect(result.name, 'John');
      expect(result.email, 'john@example.com');
      expect(result.password, 'hashed_password');
      expect(result.token, 'jwt_token');
      expect(result.createdAt, DateTime.parse('2024-01-01T00:00:00.000Z'));
      expect(result.updatedAt, DateTime.parse('2024-01-02T00:00:00.000Z'));
      expect(result.v, 0);
    });

    test('fromMap should handle missing token with empty string default', () {
      final map = {
        '_id': 'user1',
        'name': 'John',
        'email': 'john@example.com',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-01-02T00:00:00.000Z',
        '__v': 0,
      };
      final result = UserModel.fromMap(map);
      expect(result.token, '');
    });

    test('fromMap should parse default_address when present', () {
      final map = {
        '_id': 'user1',
        'name': 'John',
        'email': 'john@example.com',
        'token': 'jwt_token',
        'default_address': {
          '_id': 'addr1',
          'complete_address': 'Jl. Test',
          'receiver_name': 'John',
          'receiver_phone': '+6281234567890',
          '__v': 0,
        },
        '__v': 0,
      };
      final result = UserModel.fromMap(map);
      expect(result.defaultAddress, isNotNull);
      expect(result.defaultAddress!.id, 'addr1');
    });

    test('fromMap should handle null default_address', () {
      final result = UserModel.fromMap(tMap);
      expect(result.defaultAddress, isNull);
    });

    test('fromJson should decode JSON string', () {
      final jsonString = json.encode(tMap);
      final result = UserModel.fromJson(jsonString);
      expect(result.id, 'user1');
      expect(result.name, 'John');
    });

    test('toEntity should return a User entity', () {
      final model = UserModel.fromMap(tMap);
      final entity = model.toEntity();
      expect(entity.id, 'user1');
      expect(entity.name, 'John');
      expect(entity.email, 'john@example.com');
    });

    test('fromEntity should create model from entity', () {
      final model = UserModel.fromMap(tMap);
      final entity = model.toEntity();
      final restored = UserModel.fromEntity(entity);
      expect(restored.id, 'user1');
      expect(restored.name, 'John');
    });

    test('copyWith should create a copy with updated fields', () {
      final model = UserModel.fromMap(tMap);
      final copy = model.copyWith(name: 'Jane', token: 'new_token');
      expect(copy.name, 'Jane');
      expect(copy.token, 'new_token');
      expect(copy.id, 'user1');
    });

    test('equality should work correctly', () {
      final model1 = UserModel.fromMap(tMap);
      final model2 = UserModel.fromMap(tMap);
      expect(model1, equals(model2));
    });
  });
}
