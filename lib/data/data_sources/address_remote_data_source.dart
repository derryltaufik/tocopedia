import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/common/env_variables.dart';
import 'package:tocopedia/common/exception.dart';
import 'package:tocopedia/data/models/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<AddressModel> addAddress(
    String token, {
    String? label,
    required String completeAddress,
    String? notes,
    required String receiverName,
    required String receiverPhone,
  });

  Future<List<AddressModel>> getUserAddresses(String token);

  Future<AddressModel> getAddress(String token, String addressId);

  Future<AddressModel> updateAddress(
    String token,
    String addressId, {
    String? label,
    String? completeAddress,
    String? notes,
    String? receiverName,
    String? receiverPhone,
  });

  Future<AddressModel> deleteAddress(String token, String addressId);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final http.Client client;

  AddressRemoteDataSourceImpl({required this.client});

  @override
  Future<AddressModel> addAddress(
    String token, {
    String? label,
    required String completeAddress,
    String? notes,
    required String receiverName,
    required String receiverPhone,
  }) async {
    final body = ({
      "label": label,
      "complete_address": completeAddress,
      "notes": notes,
      "receiver_name": receiverName,
      "receiver_phone": receiverPhone,
    }..removeWhere((key, value) => value == null || value.toString().isEmpty))
        .map((key, value) => MapEntry(key, value.toString()));

    final url = Uri.parse(BASE_URL).replace(path: '/addresses');

    final response = await client.post(
      url,
      headers: defaultHeader
        ..addEntries({"Authorization": "Bearer $token"}.entries),
      body: json.encode(body),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode ~/ 100 == 2) {
      return AddressModel.fromMap(responseBody["data"]["address"]);
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<AddressModel> updateAddress(String token, String addressId,
      {String? label,
      String? completeAddress,
      String? notes,
      String? receiverName,
      String? receiverPhone}) async {
    final body = ({
      "label": label,
      "complete_address": completeAddress,
      "notes": notes,
      "receiver_name": receiverName,
      "receiver_phone": receiverPhone,
    }..removeWhere((key, value) => value == null || value.toString().isEmpty))
        .map((key, value) => MapEntry(key, value.toString()));

    final url = Uri.parse(BASE_URL).replace(path: '/addresses/$addressId');

    final response = await client.patch(
      url,
      headers: defaultHeader
        ..addEntries({"Authorization": "Bearer $token"}.entries),
      body: json.encode(body),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode ~/ 100 == 2) {
      return AddressModel.fromMap(responseBody["data"]["address"]);
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<AddressModel> deleteAddress(String token, String addressId) async {
    final url = Uri.parse(BASE_URL).replace(path: '/addresses/$addressId');

    final response = await client.delete(
      url,
      headers: defaultHeader
        ..addEntries({"Authorization": "Bearer $token"}.entries),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode ~/ 100 == 2) {
      return AddressModel.fromMap(responseBody["data"]["address"]);
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<AddressModel> getAddress(String token, String addressId) async {
    final url = Uri.parse(BASE_URL).replace(path: '/addresses/$addressId');

    final response = await client.get(
      url,
      headers: defaultHeader
        ..addEntries({"Authorization": "Bearer $token"}.entries),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode ~/ 100 == 2) {
      return AddressModel.fromMap(responseBody["data"]["address"]);
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<List<AddressModel>> getUserAddresses(String token) async {
    final url = Uri.parse(BASE_URL).replace(path: '/addresses');

    final response = await client.get(
      url,
      headers: defaultHeader
        ..addEntries({"Authorization": "Bearer $token"}.entries),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode ~/ 100 == 2) {
      return List<AddressModel>.from(
          responseBody["data"]["results"].map((x) => AddressModel.fromMap(x)));
    }

    throw ServerException(responseBody["error"].toString());
  }
}
