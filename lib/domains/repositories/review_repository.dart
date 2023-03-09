import 'dart:io';

import 'package:tocopedia/domains/entities/review.dart';

abstract class ReviewRepository {
  Future<Review> addReview(
    String token,
    String orderItemDetailId, {
    required int rating,
    List<File>? images,
    String? review,
    bool? anonymous,
  });

  Future<Review> updateReview(
    String token,
    String reviewId, {
    int? rating,
    List<String>? images,
    String? review,
    bool? anonymous,
  });

  Future<List<Review>> getProductReviews(String productId);

  Future<List<Review>> getSellerReviews(String sellerId);

  Future<List<Review>> getBuyerReviews(String token);
}
