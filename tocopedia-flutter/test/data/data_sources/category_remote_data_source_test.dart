import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tocopedia/common/exception.dart';
import 'package:tocopedia/data/data_sources/category_remote_data_source.dart';
import 'package:tocopedia/data/models/category_model.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late CategoryRemoteDataSourceImpl dataSource;
  late MockHttpClient mockClient;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockClient = MockHttpClient();
    dataSource = CategoryRemoteDataSourceImpl(client: mockClient);
  });

  final tCategoryMap = {
    '_id': 'cat1',
    'name': 'Electronics',
    'image': 'https://example.com/cat.png',
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-02T00:00:00.000Z',
    '__v': 0,
  };

  group('getAllCategories', () {
    test('should return list of CategoryModel when response is 2xx', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({
                  'data': {
                    'results': [tCategoryMap, tCategoryMap]
                  }
                }),
                200,
              ));

      final result = await dataSource.getAllCategories();

      expect(result, isA<List<CategoryModel>>());
      expect(result, hasLength(2));
      expect(result[0].id, 'cat1');
    });

    test('should return empty list when no categories', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({
                  'data': {'results': []}
                }),
                200,
              ));

      final result = await dataSource.getAllCategories();

      expect(result, isEmpty);
    });

    test('should throw ServerException when response is error', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({'error': 'Server error'}),
                500,
              ));

      expect(
        () => dataSource.getAllCategories(),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getCategory', () {
    test('should return CategoryModel when response is 2xx', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({'data': {'category': tCategoryMap}}),
                200,
              ));

      final result = await dataSource.getCategory('cat1');

      expect(result, isA<CategoryModel>());
      expect(result.id, 'cat1');
      expect(result.name, 'Electronics');
    });

    test('should throw ServerException when category not found', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({'error': 'Category not found'}),
                404,
              ));

      expect(
        () => dataSource.getCategory('invalid'),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
