import 'dart:async';
import 'dart:convert';

import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/common/exception.dart';
import 'package:tocopedia/common/env_variables.dart';
import 'package:tocopedia/data/models/review_model.dart';
import 'package:http/http.dart' as http;

abstract class ReviewRemoteDataSource {
  Future<List<ReviewModel>> getProductReviews(String productId);

  Future<List<ReviewModel>> getSellerReviews(String sellerId);

  Future<List<ReviewModel>> getBuyerReviews(String token);

  Future<ReviewModel> addReview(
    String token,
    String orderItemDetailId, {
    required int rating,
    List<String>? images,
    String? review,
    bool? anonymous,
  });

  Future<ReviewModel> updateReview(
    String token,
    String reviewId, {
    int? rating,
    List<String>? images,
    String? review,
    bool? anonymous,
  });

  Future<ReviewModel> getReview(
    String reviewId,
  );
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final http.Client client;

  ReviewRemoteDataSourceImpl({required this.client});

  @override
  Future<ReviewModel> addReview(String token, String orderItemDetailId,
      {required int rating,
      List<String>? images,
      String? review,
      bool? anonymous}) async {
    try {
      final body = ({
        "rating": rating,
        "images": images ?? [],
        "review": review,
        "anonymous": anonymous,
      }..removeWhere(
          (key, value) => value == null || value.toString().isEmpty));

      final url =
          Uri.parse(BASE_URL).replace(path: '/reviews/$orderItemDetailId');

      final response = await client
          .post(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);

      if (response.statusCode ~/ 100 == 2) {
        return ReviewModel.fromMap(responseBody["data"]["review"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<ReviewModel> updateReview(String token, String reviewId,
      {int? rating,
      List<String>? images,
      String? review,
      bool? anonymous}) async {
    try {
      final body = ({
        "rating": rating,
        "images": images ?? [],
        "review": review,
        "anonymous": anonymous,
      }..removeWhere(
          (key, value) => value == null || value.toString().isEmpty));

      final url = Uri.parse(BASE_URL).replace(path: '/reviews/$reviewId');

      final response = await client
          .patch(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
            body: json.encode(body),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);

      if (response.statusCode ~/ 100 == 2) {
        return ReviewModel.fromMap(responseBody["data"]["review"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<List<ReviewModel>> getBuyerReviews(String token) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/reviews/buyer');

      final response = await client
          .get(
            url,
            headers: defaultHeader
              ..addEntries({"Authorization": "Bearer $token"}.entries),
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);

      if (response.statusCode ~/ 100 == 2) {
        return List<ReviewModel>.from(
            responseBody["data"]["results"].map((x) => ReviewModel.fromMap(x)));
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    try {
      final url =
          Uri.parse(BASE_URL).replace(path: '/reviews/products/$productId');

      final response = await client
          .get(
            url,
            headers: defaultHeader,
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);

      if (response.statusCode ~/ 100 == 2) {
        return List<ReviewModel>.from(
            responseBody["data"]["results"].map((x) => ReviewModel.fromMap(x)));
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<List<ReviewModel>> getSellerReviews(String sellerId) async {
    try {
      final url =
          Uri.parse(BASE_URL).replace(path: '/reviews/seller/$sellerId');

      final response = await client
          .get(
            url,
            headers: defaultHeader,
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);

      if (response.statusCode ~/ 100 == 2) {
        return List<ReviewModel>.from(
            responseBody["data"]["results"].map((x) => ReviewModel.fromMap(x)));
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }

  @override
  Future<ReviewModel> getReview(String reviewId) async {
    try {
      final url = Uri.parse(BASE_URL).replace(path: '/reviews/$reviewId');

      final response = await client
          .get(
            url,
            headers: defaultHeader,
          )
          .timeout(const Duration(seconds: 5));

      final responseBody = json.decode(response.body);

      if (response.statusCode ~/ 100 == 2) {
        return ReviewModel.fromMap(responseBody["data"]["review"]);
      }

      throw ServerException(responseBody["error"].toString());
    } on TimeoutException catch (e) {
      throw ServerTimeoutException(e.duration);
    } on Exception {
      rethrow;
    }
  }
}
