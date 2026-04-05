import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tocopedia/common/exception.dart';
import 'package:tocopedia/data/data_sources/user_remote_data_source.dart';
import 'package:tocopedia/data/models/user_model.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late UserRemoteDataSourceImpl dataSource;
  late MockHttpClient mockClient;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockClient = MockHttpClient();
    dataSource = UserRemoteDataSourceImpl(client: mockClient);
  });

  final tUserMap = {
    '_id': 'user1',
    'name': 'John',
    'email': 'john@example.com',
    'token': 'jwt_token',
    '__v': 0,
  };

  group('signUp', () {
    test('should return UserModel when response is 2xx', () async {
      when(() => mockClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(
                json.encode({'data': {'user': tUserMap}}),
                201,
              ));

      final result =
          await dataSource.signUp('john@example.com', 'password123', 'John');

      expect(result, isA<UserModel>());
      expect(result.id, 'user1');
      expect(result.name, 'John');
    });

    test('should throw ServerException when response is error', () async {
      when(() => mockClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(
                json.encode({'error': 'Email already registered'}),
                400,
              ));

      expect(
        () => dataSource.signUp('john@example.com', 'password123', 'John'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('login', () {
    test('should return UserModel when response is 2xx', () async {
      when(() => mockClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(
                json.encode({'data': {'user': tUserMap}}),
                200,
              ));

      final result =
          await dataSource.login('john@example.com', 'password123');

      expect(result.id, 'user1');
      expect(result.email, 'john@example.com');
    });

    test('should throw ServerException on wrong credentials', () async {
      when(() => mockClient.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(
                json.encode({'error': 'Password incorrect'}),
                401,
              ));

      expect(
        () => dataSource.login('john@example.com', 'wrong'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getUser', () {
    test('should return UserModel with token preserved', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({'data': {'user': tUserMap}}),
                200,
              ));

      final result = await dataSource.getUser('my_token');

      expect(result.id, 'user1');
      expect(result.token, 'my_token');
    });

    test('should throw ServerException when unauthorized', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
                json.encode({'error': 'Unauthorized'}),
                401,
              ));

      expect(
        () => dataSource.getUser('invalid_token'),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('updateUser', () {
    test('should return updated UserModel with token preserved', () async {
      when(() => mockClient.patch(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(
                json.encode({
                  'data': {
                    'user': {...tUserMap, 'name': 'Jane'}
                  }
                }),
                200,
              ));

      final result = await dataSource.updateUser('my_token', name: 'Jane');

      expect(result.name, 'Jane');
      expect(result.token, 'my_token');
    });

    test('should throw ServerException on invalid update', () async {
      when(() => mockClient.patch(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(
                json.encode({'error': 'Invalid field'}),
                400,
              ));

      expect(
        () => dataSource.updateUser('my_token', name: ''),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
