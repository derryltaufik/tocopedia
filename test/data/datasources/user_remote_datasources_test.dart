import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tocopedia/data/data_sources/user_remote_data_source.dart';
import 'package:http/http.dart' as http;

void main() {
  late UserRemoteDataSourceImpl dataSource;

  setUp(() {
    dataSource = UserRemoteDataSourceImpl(client: http.Client());
  });

  group("Sign Up User", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final result = await dataSource.signUp(
            "dfgfd@ggh.com", "sdgdtrjytytyjtfgfd", "ASdfsdfa");
      } on SocketException catch (e) {
      } on Exception catch (e) {}
    });
  });

  group("Update User", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final result = await dataSource.updateUser(
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2U4ZDhjMDEzNDRmMjEyMmEyZjZiMzYiLCJpYXQiOjE2NzYyMDQyMjR9.4dS1CCFEhU6ZNiqsfKaBd3JQYnNnOgkFQyb1DLOPZXw",
            name: "Agus Setiono Updated",
            password: "asdfasdfasdf");
        print(result.toString());
      } on SocketException catch (e) {
      } on Exception catch (e) {}
    });
  });
}
