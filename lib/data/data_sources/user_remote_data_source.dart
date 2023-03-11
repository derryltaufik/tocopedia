import 'dart:async';
import 'dart:convert';

import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/common/exception.dart';
import 'package:tocopedia/common/env_variables.dart';
import 'package:tocopedia/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class UserRemoteDataSource {
  Future<UserModel> signUp(String email, String password, String name);

  Future<UserModel> login(String email, String password);

  Future<UserModel> getUser(String token);

  Future<UserModel> updateUser(String token, {String? name, String? addressId});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> signUp(String email, String password, String name) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/auth/signup');

      final response = await client
          .post(
            url,
            headers: defaultHeader,
            body: json.encode({
              "email": email,
              "password": password,
              "name": name,
            }),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return UserModel.fromMap(responseBody["data"]["user"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/auth/login');

      final response = await client
          .post(
            url,
            headers: defaultHeader,
            body: json.encode({
              "email": email,
              "password": password,
            }),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);

      if (response.statusCode ~/ 100 == 2) {
        return UserModel.fromMap(responseBody["data"]["user"]);
      }
      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<UserModel> getUser(String token) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/users');

      final response = await client
          .get(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return UserModel.fromMap(responseBody["data"]["user"])
            .copyWith(token: token);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<UserModel> updateUser(String token,
      {String? name, String? addressId}) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/users');
      final response = await client
          .patch(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
            body: json.encode({
              "name": name,
              "default_address": addressId,
            }..removeWhere((key, value) => value == null)),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return UserModel.fromMap(responseBody["data"]["user"])
            .copyWith(token: token);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }
}
