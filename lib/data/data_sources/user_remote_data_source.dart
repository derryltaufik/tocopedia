import 'dart:convert';

import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/common/exception.dart';
import 'package:tocopedia/common/env_variables.dart';
import 'package:tocopedia/data/models/address_model.dart';
import 'package:tocopedia/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class UserRemoteDataSource {
  Future<UserModel> signUp(String email, String password, String name);

  Future<UserModel> login(String email, String password);

  Future<UserModel> getUser(String token);

  Future<UserModel> updateUser(String token,
      {String? name, String? password, AddressModel? defaultAddress});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> signUp(String email, String password, String name) async {
    final url = Uri.parse(BASE_URL).replace(path: '/auth/signup');

    final response = await client.post(
      url,
      headers: defaultHeader,
      body: json.encode({
        "email": email,
        "password": password,
        "name": name,
      }),
    );

    final responseBody = json.decode(response.body);
    if (response.statusCode ~/ 100 == 2) {
      return UserModel.fromMap(responseBody["data"]["user"]);
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final url = Uri.parse(BASE_URL).replace(path: '/auth/login');

    final response = await client.post(
      url,
      headers: defaultHeader,
      body: json.encode({
        "email": email,
        "password": password,
      }),
    );

    final responseBody = json.decode(response.body);
    if (response.statusCode ~/ 100 == 2) {
      return UserModel.fromMap(responseBody["data"]["user"]);
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<UserModel> getUser(String token) async {
    final url = Uri.parse(BASE_URL).replace(path: '/users');

    final response = await client.get(
      url,
      headers: defaultHeader
        ..addEntries({"Authorization": "Bearer $token"}.entries),
    );

    final responseBody = json.decode(response.body);
    if (response.statusCode ~/ 100 == 2) {
      return UserModel.fromMap(responseBody["data"]["user"])
          .copyWith(token: token);
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<UserModel> updateUser(String token,
      {String? name, String? password, AddressModel? defaultAddress}) async {
    final url = Uri.parse(BASE_URL).replace(path: '/users');
    final response = await client.patch(
      url,
      headers: defaultHeader
        ..addEntries({"Authorization": "Bearer $token"}.entries),
      body: json.encode({
        "name": name,
        "password": password,
        "defaultAddress": defaultAddress?.id,
      }..removeWhere((key, value) => value == null)),
    );

    final responseBody = json.decode(response.body);
    if (response.statusCode ~/ 100 == 2) {
      return UserModel.fromMap(responseBody["data"]["user"])
          .copyWith(token: token);
    }

    throw ServerException(responseBody["error"].toString());
  }
}
