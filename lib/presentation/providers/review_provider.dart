import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tocopedia/domains/entities/review.dart';
import 'package:tocopedia/domains/use_cases/review/add_review.dart';
import 'package:tocopedia/domains/use_cases/review/get_buyer_reviews.dart';
import 'package:tocopedia/domains/use_cases/review/get_product_reviews.dart';
import 'package:tocopedia/domains/use_cases/review/get_seller_reviews.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';

class ReviewProvider with ChangeNotifier {
  final AddReview _addReview;

  // final UpdateReview _updateReview;
  final GetBuyerReviews _getBuyerReviews;
  final GetSellerReviews _getSellerReviews;
  final GetProductReviews _getProductReviews;

  final String? _authToken;

  List<Review>? _buyerReviews;
  List<Review>? _sellerReviews;
  List<Review>? _productReviews;

  List<Review>? get buyerReviews => [...?_buyerReviews];

  List<Review>? get sellerReviews => [...?_sellerReviews];

  List<Review>? get productReviews => [...?_productReviews];

  String _message = "";

  String get message => _message;

  ReviewProvider({
    required GetProductReviews getProductReviews,
    required GetSellerReviews getSellerReviews,
    required GetBuyerReviews getBuyerReviews,
    required AddReview addReview,
    required String? authToken,
  })  : _getProductReviews = getProductReviews,
        _getSellerReviews = getSellerReviews,
        _getBuyerReviews = getBuyerReviews,
        _addReview = addReview,
        _authToken = authToken;

  ProviderState _getBuyerReviewsState = ProviderState.empty;

  ProviderState get getBuyerReviewsState => _getBuyerReviewsState;

  ProviderState _getSellerReviewsState = ProviderState.empty;

  ProviderState get getSellerReviewsState => _getSellerReviewsState;

  ProviderState _getProductReviewsState = ProviderState.empty;

  ProviderState get getProductReviewsState => _getProductReviewsState;

  Future<void> getBuyerReviews() async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      _getBuyerReviewsState = ProviderState.loading;
      notifyListeners();

      final reviews = await _getBuyerReviews.execute(_authToken!);

      _buyerReviews = reviews;
      _getBuyerReviewsState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getBuyerReviewsState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<void> getProductReviews(String productId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      _getProductReviewsState = ProviderState.loading;
      notifyListeners();

      final reviews = await _getProductReviews.execute(productId);

      _productReviews = reviews;
      _getProductReviewsState = ProviderState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      _getProductReviewsState = ProviderState.error;
      notifyListeners();
    }
  }

  Future<Review> addReview(
    String orderItemDetailId, {
    required int rating,
    List<File>? images,
    String? review,
    bool? anonymous,
  }) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");

      final newReview = await _addReview.execute(
        _authToken!,
        orderItemDetailId,
        rating: rating,
        review: review,
        images: images,
        anonymous: anonymous,
      );

      getBuyerReviews();
      return newReview;
    } catch (e) {
      rethrow;
    }
  }

  bool _verifyToken() {
    return (_authToken != null && _authToken!.isNotEmpty);
  }
}
