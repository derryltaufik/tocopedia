import 'dart:async';
import 'dart:convert';

import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/common/exception.dart';
import 'package:tocopedia/common/env_variables.dart';
import 'package:http/http.dart' as http;
import 'package:tocopedia/data/models/cart_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart(String token);

  Future<CartModel> addToCart(String token, String productId);

  Future<CartModel> removeFromCart(String token, String productId);

  Future<CartModel> selectCartItem(String token, String productId);

  Future<CartModel> unSelectCartItem(String token, String productId);

  Future<CartModel> selectSeller(String token, String sellerId);

  Future<CartModel> unselectSeller(String token, String sellerId);

  Future<CartModel> updateCart(String token, String productId, int quantity);

  Future<CartModel> clearCart(String token);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final http.Client client;

  CartRemoteDataSourceImpl({required this.client});

  @override
  Future<CartModel> getCart(String token) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/cart');

      final response = await client
          .get(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return CartModel.fromMap(responseBody["data"]["cart"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<CartModel> clearCart(String token) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/cart/clear');

      final response = await client
          .patch(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);

      if (response.statusCode ~/ 100 == 2) {
        return CartModel.fromMap(responseBody["data"]["cart"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<CartModel> addToCart(String token, String productId) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/cart/add/$productId');

      final response = await client
          .patch(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return CartModel.fromMap(responseBody["data"]["cart"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<CartModel> removeFromCart(String token, String productId) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/cart/remove/$productId');

      final response = await client
          .patch(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return CartModel.fromMap(responseBody["data"]["cart"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<CartModel> selectCartItem(String token, String productId) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/cart/select/$productId');

      final response = await client
          .patch(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return CartModel.fromMap(responseBody["data"]["cart"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<CartModel> selectSeller(String token, String sellerId) async {
    try {
      final url =
          Uri.parse(BASE_URL).replace(path: '/cart/select/seller/$sellerId');
      final response = await client
          .patch(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return CartModel.fromMap(responseBody["data"]["cart"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<CartModel> unSelectCartItem(String token, String productId) async {
    try {
      final url =
          Uri.parse(BASE_URL).replace(path: '/cart/unselect/$productId');

      final response = await client
          .patch(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return CartModel.fromMap(responseBody["data"]["cart"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<CartModel> unselectSeller(String token, String sellerId) async {
    try {
      final url =
          Uri.parse(BASE_URL).replace(path: '/cart/unselect/seller/$sellerId');

      final response = await client
          .patch(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return CartModel.fromMap(responseBody["data"]["cart"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<CartModel> updateCart(
      String token, String productId, int quantity) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/cart/update/$productId');

      final response = await client
          .patch(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
            body: json.encode({"quantity": quantity}),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return CartModel.fromMap(responseBody["data"]["cart"]);
      }
      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }
}
