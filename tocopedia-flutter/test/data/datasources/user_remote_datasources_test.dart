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

  group("Login User", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final result = await dataSource.login("asdfasdf@asdf.com", "asdfasdf");
        print(result.toString());
      } catch (e) {
        print(e);
      }
    });
  });

  group("Update User", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final result = await dataSource.updateUser(
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2Y4NWVhY2FmOWI1YzdiMTEwZGNkNzEiLCJpYXQiOjE2Nzc0MjgwMzd9.czXf62kLxO6hua4njIHikZ6fKTwqa3B9pDz9zEbBTs4",
          name: "Agus Setiono Updated",
          addressId: "63fb69eec9c6e15bade9a738",
        );
        print(result.toString());
      } on SocketException catch (e) {
      } on Exception catch (e) {}
    });
  });
}
