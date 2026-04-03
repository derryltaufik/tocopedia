import 'dart:async';
import 'dart:convert';

import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/common/exception.dart';
import 'package:tocopedia/common/env_variables.dart';
import 'package:http/http.dart' as http;
import 'package:tocopedia/data/models/wishlist_model.dart';

abstract class WishlistRemoteDataSource {
  Future<WishlistModel> getWishlist(String token);

  Future<WishlistModel> addWishlist(String token, String productId);

  Future<WishlistModel> deleteWishlist(String token, String productId);
}

class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final http.Client client;

  WishlistRemoteDataSourceImpl({required this.client});

  @override
  Future<WishlistModel> addWishlist(String token, String productId) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/wishlist/$productId');

      final response = await client
          .post(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return WishlistModel.fromMap(responseBody["data"]["wishlist"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<WishlistModel> deleteWishlist(String token, String productId) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/wishlist/$productId');

      final response = await client
          .delete(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return WishlistModel.fromMap(responseBody["data"]["wishlist"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<WishlistModel> getWishlist(String token) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/wishlist');

      final response = await client
          .get(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);
      if (response.statusCode ~/ 100 == 2) {
        return WishlistModel.fromMap(responseBody["data"]["wishlist"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }
}
