import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tocopedia/data/data_sources/product_remote_data_source.dart';
import 'package:tocopedia/data/data_sources/user_remote_data_source.dart';
import 'package:http/http.dart' as http;

void main() {
  late ProductRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = ProductRemoteDataSourceImpl(client: http.Client());
  });

  group("Get Product", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final result = await dataSource.getProduct("63e91cbfcb3199d254550b73");
        print(result.toString());
      } on SocketException catch (e) {
      } on Exception catch (e) {}
    });
  });

}
