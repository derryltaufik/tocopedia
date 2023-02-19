import 'dart:convert';

import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/common/exception.dart';
import 'package:tocopedia/common/env_variables.dart';
import 'package:http/http.dart' as http;
import 'package:tocopedia/data/models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> checkout(String token, String addressId);

  Future<OrderModel> getOrder(String token, String orderId);

  Future<List<OrderModel>> getUserOrders(String token);

  Future<OrderModel> payOrder(String token, String orderId);

  Future<OrderModel> cancelOrder(String token, String orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final http.Client client;

  OrderRemoteDataSourceImpl({required this.client});

  @override
  Future<OrderModel> checkout(String token, String addressId) async {
    final url = Uri.parse(BASE_URL).replace(path: '/orders/checkout');

    final response = await client.post(
      url,
      headers: defaultHeader
        ..addEntries({"Authorization": "Bearer $token"}.entries),
      body: json.encode({"address": addressId}),
    );

    final responseBody = json.decode(response.body);
    if (response.statusCode ~/ 100 == 2) {
      return OrderModel.fromMap(responseBody["data"]["order"]);
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<OrderModel> payOrder(String token, String orderId) async {
    final url = Uri.parse(BASE_URL).replace(path: '/orders/$orderId/pay');

    final response = await client.patch(url,
        headers: defaultHeader
          ..addEntries({"Authorization": "Bearer $token"}.entries));

    final responseBody = json.decode(response.body);
    if (response.statusCode ~/ 100 == 2) {
      return OrderModel.fromMap(responseBody["data"]["order"]);
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<OrderModel> cancelOrder(String token, String orderId) async {
    final url = Uri.parse(BASE_URL).replace(path: '/orders/$orderId/cancel');

    final response = await client.patch(url,
        headers: defaultHeader
          ..addEntries({"Authorization": "Bearer $token"}.entries));

    final responseBody = json.decode(response.body);
    if (response.statusCode ~/ 100 == 2) {
      return OrderModel.fromMap(responseBody["data"]["order"]);
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<OrderModel> getOrder(String token, String orderId) async {
    final url = Uri.parse(BASE_URL).replace(path: '/orders/$orderId');

    final response = await client.get(url,
        headers: defaultHeader
          ..addEntries({"Authorization": "Bearer $token"}.entries));

    final responseBody = json.decode(response.body);
    if (response.statusCode ~/ 100 == 2) {
      return OrderModel.fromMap(responseBody["data"]["order"]);
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<List<OrderModel>> getUserOrders(String token) async {
    final url = Uri.parse(BASE_URL).replace(path: '/orders');

    final response = await client.get(url,
        headers: defaultHeader
          ..addEntries({"Authorization": "Bearer $token"}.entries));

    final responseBody = json.decode(response.body);
    if (response.statusCode ~/ 100 == 2) {
      return List<OrderModel>.from(
          responseBody["data"]["results"].map((x) => OrderModel.fromMap(x)));
    }

    throw ServerException(responseBody["error"].toString());
  }
}
