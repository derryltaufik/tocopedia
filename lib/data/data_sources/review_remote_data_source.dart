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
    String orderItemId, {
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
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final http.Client client;

  ReviewRemoteDataSourceImpl({required this.client});

  @override
  Future<ReviewModel> addReview(String token, String orderItemId,
      {required int rating,
      List<String>? images,
      String? review,
      bool? anonymous}) {
    // TODO: implement addReview
    throw UnimplementedError();
  }

  @override
  Future<ReviewModel> updateReview(String token, String reviewId,
      {int? rating, List<String>? images, String? review, bool? anonymous}) {
    // TODO: implement updateReview
    throw UnimplementedError();
  }

  @override
  Future<List<ReviewModel>> getBuyerReviews(String token) async {
    final url = Uri.parse(BASE_URL).replace(path: '/reviews/buyer');

    final response = await client.get(
      url,
      headers: defaultHeader
        ..addEntries({"Authorization": "Bearer $token"}.entries),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode ~/ 100 == 2) {
      return List<ReviewModel>.from(
          responseBody["data"]["results"].map((x) => ReviewModel.fromMap(x)));
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    final url =
        Uri.parse(BASE_URL).replace(path: '/reviews/products/$productId');

    final response = await client.get(
      url,
      headers: defaultHeader,
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode ~/ 100 == 2) {
      return List<ReviewModel>.from(
          responseBody["data"]["results"].map((x) => ReviewModel.fromMap(x)));
    }

    throw ServerException(responseBody["error"].toString());
  }

  @override
  Future<List<ReviewModel>> getSellerReviews(String sellerId) async {
    final url =
    Uri.parse(BASE_URL).replace(path: '/reviews/seller/$sellerId');

    final response = await client.get(
      url,
      headers: defaultHeader,
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode ~/ 100 == 2) {
      return List<ReviewModel>.from(
          responseBody["data"]["results"].map((x) => ReviewModel.fromMap(x)));
    }

    throw ServerException(responseBody["error"].toString());
  }
}