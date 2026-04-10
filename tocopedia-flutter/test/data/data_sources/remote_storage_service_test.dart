import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:tocopedia/common/env_variables.dart';
import 'package:tocopedia/data/data_sources/remote_storage_service.dart';

class MockHttpClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  late RemoteStorageServiceImpl service;
  late MockHttpClient mockClient;
  late Directory tempDir;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockClient = MockHttpClient();
    service = RemoteStorageServiceImpl(client: mockClient);
    tempDir = Directory.systemTemp.createTempSync('remote_storage_test_');
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  File createTempFile(String name, {List<int> bytes = const [1, 2, 3]}) {
    final file = File('${tempDir.path}/$name');
    file.writeAsBytesSync(bytes);
    return file;
  }

  const tToken = 'test_token';
  const tPresignedUrl =
      'https://bucket.s3.amazonaws.com/uploads/abc.jpg?X-Amz-Signature=xxx';
  const tPublicUrl = 'https://bucket.s3.amazonaws.com/uploads/abc.jpg';

  String presignResponseBody() => json.encode({
        'data': {
          'presignedUrl': tPresignedUrl,
          'publicUrl': tPublicUrl,
          'key': 'uploads/abc.jpg',
          'expiresIn': 300,
          'maxFileSize': 5242880,
        }
      });

  group('uploadImage - success', () {
    test('should return publicUrl when both presign and PUT succeed', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(presignResponseBody(), 200));
      when(() => mockClient.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 200));

      final file = createTempFile('photo.jpg');
      final result = await service.uploadImage(tToken, file);

      expect(result, tPublicUrl);
    });

    test('should call presign endpoint with correct query params and auth',
        () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(presignResponseBody(), 200));
      when(() => mockClient.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 200));

      final file = createTempFile('photo.jpg');
      await service.uploadImage(tToken, file);

      final captured = verify(() => mockClient.get(captureAny(),
          headers: captureAny(named: 'headers'))).captured;
      final uri = captured[0] as Uri;
      final headers = captured[1] as Map<String, String>;

      expect(uri.toString(), startsWith('$BASE_URL/upload/presign'));
      expect(uri.queryParameters['contentType'], 'image/jpeg');
      expect(uri.queryParameters['extension'], '.jpg');
      expect(headers['Authorization'], 'Bearer $tToken');
    });

    test('should PUT file bytes to presigned URL with Content-Type header',
        () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(presignResponseBody(), 200));
      when(() => mockClient.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 200));

      final fileBytes = [10, 20, 30, 40];
      final file = createTempFile('photo.jpg', bytes: fileBytes);
      await service.uploadImage(tToken, file);

      final captured = verify(() => mockClient.put(captureAny(),
          headers: captureAny(named: 'headers'),
          body: captureAny(named: 'body'))).captured;
      final uri = captured[0] as Uri;
      final headers = captured[1] as Map<String, String>;
      final body = captured[2] as List<int>;

      expect(uri.toString(), tPresignedUrl);
      expect(headers['Content-Type'], 'image/jpeg');
      expect(body, fileBytes);
    });
  });

  group('uploadImage - content type detection', () {
    setUp(() {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(presignResponseBody(), 200));
      when(() => mockClient.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('', 200));
    });

    Future<Map<String, String>> uploadAndCaptureQuery(String filename) async {
      final file = createTempFile(filename);
      await service.uploadImage(tToken, file);
      final captured = verify(() => mockClient.get(captureAny(),
          headers: any(named: 'headers'))).captured;
      return (captured.last as Uri).queryParameters;
    }

    test('should detect image/jpeg for .jpg', () async {
      final params = await uploadAndCaptureQuery('a.jpg');
      expect(params['contentType'], 'image/jpeg');
      expect(params['extension'], '.jpg');
    });

    test('should detect image/jpeg for .jpeg', () async {
      final params = await uploadAndCaptureQuery('a.jpeg');
      expect(params['contentType'], 'image/jpeg');
      expect(params['extension'], '.jpeg');
    });

    test('should detect image/png for .png', () async {
      final params = await uploadAndCaptureQuery('a.png');
      expect(params['contentType'], 'image/png');
      expect(params['extension'], '.png');
    });

    test('should detect image/gif for .gif', () async {
      final params = await uploadAndCaptureQuery('a.gif');
      expect(params['contentType'], 'image/gif');
      expect(params['extension'], '.gif');
    });

    test('should detect image/webp for .webp', () async {
      final params = await uploadAndCaptureQuery('a.webp');
      expect(params['contentType'], 'image/webp');
      expect(params['extension'], '.webp');
    });

    test('should handle uppercase extension', () async {
      final params = await uploadAndCaptureQuery('a.PNG');
      expect(params['contentType'], 'image/png');
    });

    test('should default to image/jpeg when extension unknown', () async {
      final params = await uploadAndCaptureQuery('a.bmp');
      expect(params['contentType'], 'image/jpeg');
    });

    test('should default to .jpg when file has no extension', () async {
      final params = await uploadAndCaptureQuery('noext');
      expect(params['extension'], '.jpg');
      expect(params['contentType'], 'image/jpeg');
    });
  });

  group('uploadImage - failure', () {
    test('should throw when presign returns non-200 with error message',
        () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(
              json.encode({'error': 'Invalid content type'}), 400));

      final file = createTempFile('photo.jpg');
      expect(
        () => service.uploadImage(tToken, file),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Invalid content type'),
        )),
      );
    });

    test('should throw when presign returns 401', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async =>
              http.Response(json.encode({'error': 'Unauthorized'}), 401));

      final file = createTempFile('photo.jpg');
      expect(
        () => service.uploadImage(tToken, file),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw when S3 PUT fails', () async {
      when(() => mockClient.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(presignResponseBody(), 200));
      when(() => mockClient.put(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('forbidden', 403));

      final file = createTempFile('photo.jpg');
      expect(
        () => service.uploadImage(tToken, file),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to upload image to storage'),
        )),
      );
    });
  });
}
