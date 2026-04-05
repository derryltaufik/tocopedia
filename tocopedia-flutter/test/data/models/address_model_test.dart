import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tocopedia/data/models/address_model.dart';

void main() {
  final tMap = {
    '_id': 'addr1',
    'owner': {
      '_id': 'user1',
      'name': 'John',
      'email': 'john@example.com',
      '__v': 0,
    },
    'label': 'Home',
    'complete_address': 'Jl. Test No. 1',
    'notes': 'Near the park',
    'receiver_name': 'John Doe',
    'receiver_phone': '+6281234567890',
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-02T00:00:00.000Z',
    '__v': 0,
  };

  group('AddressModel', () {
    test('fromMap should return a valid model', () {
      final result = AddressModel.fromMap(tMap);
      expect(result.id, 'addr1');
      expect(result.label, 'Home');
      expect(result.completeAddress, 'Jl. Test No. 1');
      expect(result.notes, 'Near the park');
      expect(result.receiverName, 'John Doe');
      expect(result.receiverPhone, '+6281234567890');
      expect(result.v, 0);
    });

    test('fromMap should parse snake_case keys correctly', () {
      final result = AddressModel.fromMap(tMap);
      expect(result.completeAddress, 'Jl. Test No. 1');
      expect(result.receiverName, 'John Doe');
      expect(result.receiverPhone, '+6281234567890');
    });

    test('fromMap should parse nested owner', () {
      final result = AddressModel.fromMap(tMap);
      expect(result.owner, isNotNull);
      expect(result.owner!.id, 'user1');
    });

    test('fromMap should handle null owner', () {
      final map = {
        '_id': 'addr1',
        'complete_address': 'Jl. Test No. 1',
        'receiver_name': 'John',
        'receiver_phone': '+6281234567890',
        '__v': 0,
      };
      final result = AddressModel.fromMap(map);
      expect(result.owner, isNull);
    });

    test('toMap should use snake_case keys', () {
      final result = AddressModel.fromMap(tMap).toMap();
      expect(result['_id'], 'addr1');
      expect(result['complete_address'], 'Jl. Test No. 1');
      expect(result['receiver_name'], 'John Doe');
      expect(result['receiver_phone'], '+6281234567890');
      expect(result['__v'], 0);
    });

    test('fromJson should decode JSON string', () {
      final jsonString = json.encode(tMap);
      final result = AddressModel.fromJson(jsonString);
      expect(result.id, 'addr1');
      expect(result.completeAddress, 'Jl. Test No. 1');
    });

    test('toEntity should return an Address entity', () {
      final model = AddressModel.fromMap(tMap);
      final entity = model.toEntity();
      expect(entity.id, 'addr1');
      expect(entity.completeAddress, 'Jl. Test No. 1');
      expect(entity.receiverName, 'John Doe');
    });

    test('fromEntity should create model from entity', () {
      final model = AddressModel.fromMap(tMap);
      final entity = model.toEntity();
      final restored = AddressModel.fromEntity(entity);
      expect(restored.id, 'addr1');
      expect(restored.completeAddress, 'Jl. Test No. 1');
    });

    test('copyWith should create a copy with updated fields', () {
      final model = AddressModel.fromMap(tMap);
      final copy = model.copyWith(label: 'Office');
      expect(copy.label, 'Office');
      expect(copy.id, 'addr1');
    });

    test('equality should work correctly', () {
      final model1 = AddressModel.fromMap(tMap);
      final model2 = AddressModel.fromMap(tMap);
      expect(model1, equals(model2));
    });
  });
}
