import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tocopedia/data/data_sources/category_remote_data_source.dart';
import 'package:http/http.dart' as http;

void main() {
  late CategoryRemoteDataSource dataSource;

  setUp(() {
    dataSource = CategoryRemoteDataSourceImpl(client: http.Client());
  });

  group("Get All Categories", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final result = await dataSource.getAllCategories();
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });

  group("Get Category", () {
    test('ergerherreer', () async {
      try {
        final result = await dataSource.getCategory("63f85eacaf9b5c7b110dcd59");
        print(result.toString());
      } on SocketException catch (e) {
        print(e);
      } on Exception catch (e) {
        print(e);
      }
    });
  });
}
