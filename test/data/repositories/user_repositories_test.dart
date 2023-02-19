import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tocopedia/data/data_sources/user_local_data_source.dart';
import 'package:tocopedia/data/data_sources/user_remote_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:tocopedia/data/repositories/user_repository_impl.dart';

void main() {
  late UserRepositoryImpl repository;

  setUp(() {
    repository = UserRepositoryImpl(
        remoteDataSource: UserRemoteDataSourceImpl(client: http.Client()),
        localDataSource: UserLocalDataSourceImpl());
  });

  group("Sign Up User", () {
    test('should return User Model when the response code is 200', () async {
      try {
        final result = await repository.signUp(
            "gfdgfd@ggh.com", "sdgdtrjytytyjtfgfd", "ASdfsdfa");
        print(result);
      } catch (e) {
        rethrow;
      }
    });
  });

  group("Login User", () {
    test('sgfdgfd', () async {
      try {
        final result = await repository.login("asdfasdf@asdf.com", "asdfasdf");
        print(result.token);
      } catch (e) {
        rethrow;
      }
    });
  });

  group("Get User", () {
    test('sasdfasd', () async {
      try {
        final result = await repository.getUser(
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2U4ZDhjMDEzNDRmMjEyMmEyZjZiMzYiLCJpYXQiOjE2NzYyMDQyMjR9.4dS1CCFEhU6ZNiqsfKaBd3JQYnNnOgkFQyb1DLOPZXw");
        print(result.token);
      } catch (e) {
        rethrow;
      }
    });
  });

  group("Save and autologin user", () {
    test('save user', () async {
      // SharedPreferences.setMockInitialValues({});
      // try {
      //   await repository.saveUser(User(
      //       id: "",
      //       name: "",
      //       email: "",
      //       password: "",
      //       token:
      //           "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2U4ZDhjMDEzNDRmMjEyMmEyZjZiMzYiLCJpYXQiOjE2NzYyMDQyMjR9.4dS1CCFEhU6ZNiqsfKaBd3JQYnNnOgkFQyb1DLOPZXw",
      //       createdAt: DateTime.parse("2000-01-01"),
      //       updatedAt: DateTime.parse("2000-01-01"),
      //       v: 1));
      // } catch (e) {
      //   rethrow;
      // }
    });

    test('autologin user', () async {
      try {
        SharedPreferences.setMockInitialValues({
          "token":
              "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2M2U4ZDhjMDEzNDRmMjEyMmEyZjZiMzYiLCJpYXQiOjE2NzYyMDQyMjR9.4dS1CCFEhU6ZNiqsfKaBd3JQYnNnOgkFQyb1DLOPZXw"
        }); //set values here

        final result = await repository.autoLogin();
        print(result.email);
      } catch (e) {
        rethrow;
      }
    });
  });
}
