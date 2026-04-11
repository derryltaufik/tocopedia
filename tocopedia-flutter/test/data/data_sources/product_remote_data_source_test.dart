import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tocopedia/common/exception.dart';
import 'package:tocopedia/data/data_sources/product_remote_data_source.dart';
import 'package:tocopedia/data/models/product_model.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late ProductRemoteDataSourceImpl dataSource;
  late MockHttpClient mockClient;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockClient = MockHttpClient();
    dataSource = ProductRemoteDataSourceImpl(client: mockClient);
  });

  final tProductMap = {
    '_id': 'prod1',
    'owner': {'_id': 'user1', 'name': 'Seller', 'email': 'seller@test.com', '__v': 0},
    'name': 'Test Product',
    'images': ['https://example.com/img.png'],
    'price': 50000,
    'stock': 10,
    'SKU': 'SKU-001',
    'description': 'A test product',
    'status': 'active',
    'category': {'_id': 'cat1', 'name': 'Electronics', 'image': 'https://example.com/cat.png', '__v': 0},
    'total_sold': 5,
    'total_rating': 3,
    'average_rating': 4.5,
    'createdAt': '2024-01-01T00:00:00.000Z',
    'updatedAt': '2024-01-02T00:00:00.000Z',
    '__v': 0,
  };

  group('getProduct', () {
    test('should return ProductModel when response is 200', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({'data': {'product': tProductMap}}),
                200,
              ));

      final result = await dataSource.getProduct('prod1');

      expect(result, isA<ProductModel>());
      expect(result.id, 'prod1');
      expect(result.name, 'Test Product');
    });

    test('should throw ServerException when response is error', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({'error': 'Product not found'}),
                404,
              ));

      expect(
        () => dataSource.getProduct('invalid'),
        throwsA(isA<ServerException>()),
      );
    });

    test('should throw ServerTimeoutException on timeout', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async =>
              Future.delayed(const Duration(seconds: 10), () => http.Response('', 200)));

      expect(
        () => dataSource.getProduct('prod1'),
        throwsA(isA<ServerTimeoutException>()),
      );
    });
  });

  group('searchProduct', () {
    test('should return list of ProductModel when response is 200', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({
                  'data': {
                    'results': [tProductMap]
                  }
                }),
                200,
              ));

      final result = await dataSource.searchProduct(query: 'test');

      expect(result, isA<List<ProductModel>>());
      expect(result, hasLength(1));
      expect(result[0].id, 'prod1');
    });

    test('should pass query parameters correctly', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({
                  'data': {'results': []}
                }),
                200,
              ));

      await dataSource.searchProduct(
        query: 'laptop',
        minimumPrice: 1000,
        maximumPrice: 5000,
        sortBy: 'price',
        sortOrder: 'asc',
      );

      final captured = verify(() => mockClient.get(captureAny(), headers: any(named: 'headers'))).captured;
      final uri = captured.first as Uri;
      expect(uri.queryParameters['q'], 'laptop');
      expect(uri.queryParameters['min-price'], '1000');
      expect(uri.queryParameters['max-price'], '5000');
      expect(uri.queryParameters['sort-by'], 'price');
      expect(uri.queryParameters['sort-order'], 'asc');
    });

    test('should filter out null query parameters', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({
                  'data': {'results': []}
                }),
                200,
              ));

      await dataSource.searchProduct(query: 'test');

      final captured = verify(() => mockClient.get(captureAny(), headers: any(named: 'headers'))).captured;
      final uri = captured.first as Uri;
      expect(uri.queryParameters.containsKey('min-price'), isFalse);
    });

    test('should throw ServerException when response is error', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({'error': 'Server error'}),
                500,
              ));

      expect(
        () => dataSource.searchProduct(query: 'test'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getPopularProducts', () {
    test('should return list of ProductModel when response is 200', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({
                  'data': {
                    'results': [tProductMap, tProductMap]
                  }
                }),
                200,
              ));

      final result = await dataSource.getPopularProducts();

      expect(result, hasLength(2));
    });
  });

  group('getUserProducts', () {
    test('should return list of ProductModel with auth header', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({
                  'data': {
                    'results': [tProductMap]
                  }
                }),
                200,
              ));

      final result = await dataSource.getUserProducts('test_token');

      expect(result, hasLength(1));
      verify(() => mockClient.get(
            any(),
            headers: any(
              named: 'headers',
              that: containsPair('Authorization', 'Bearer test_token'),
            ),
          )).called(1);
    });
  });

  group('addProduct', () {
    test('should return ProductModel when response is 2xx', () async {
      when(() => mockClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(
                json.encode({'data': {'product': tProductMap}}),
                201,
              ));

      final result = await dataSource.addProduct(
        'test_token',
        name: 'Test Product',
        images: ['https://example.com/img.png'],
        price: 50000,
        stock: 10,
        description: 'A test product',
        categoryId: 'cat1',
      );

      expect(result.id, 'prod1');
    });

    test('should throw ServerException when response is error', () async {
      when(() => mockClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(
                json.encode({'error': 'Validation failed'}),
                400,
              ));

      expect(
        () => dataSource.addProduct(
          'test_token',
          name: 'Test',
          images: ['img.png'],
          price: 50000,
          stock: 10,
          description: 'Test',
          categoryId: 'cat1',
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('updateProduct', () {
    test('should return updated ProductModel when response is 2xx', () async {
      when(() => mockClient.patch(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(
                json.encode({'data': {'product': tProductMap}}),
                200,
              ));

      final result = await dataSource.updateProduct(
        'test_token',
        'prod1',
        name: 'Updated Product',
      );

      expect(result.id, 'prod1');
    });
  });

  group('deleteProduct', () {
    test('should return deleted ProductModel when response is 2xx', () async {
      when(() => mockClient.delete(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({'data': {'product': tProductMap}}),
                200,
              ));

      final result = await dataSource.deleteProduct('test_token', 'prod1');

      expect(result.id, 'prod1');
    });

    test('should throw ServerException when response is error', () async {
      when(() => mockClient.delete(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({'error': 'Unauthorized'}),
                401,
              ));

      expect(
        () => dataSource.deleteProduct('test_token', 'prod1'),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
