import 'dart:io';

import 'package:tocopedia/data/data_sources/remote_storage_service.dart';
import 'package:tocopedia/data/data_sources/review_remote_data_source.dart';
import 'package:tocopedia/domains/entities/review.dart';

import 'package:tocopedia/domains/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;
  final RemoteStorageService remoteStorageService;

  ReviewRepositoryImpl(
      {required this.remoteDataSource, required this.remoteStorageService});

  @override
  Future<Review> addReview(String token, String orderItemDetailId,
      {required int rating,
      List<File>? images,
      String? review,
      bool? anonymous}) async {
    List<String> imageUrls = [];

    if (images != null) {
      for (int i = 0; i < images.length; i++) {
        final imageUrl = await remoteStorageService.uploadImage(images[i]);
        imageUrls.add(imageUrl);
      }
    }

    final result = await remoteDataSource.addReview(token, orderItemDetailId,
        rating: rating,
        review: review,
        images: imageUrls,
        anonymous: anonymous);

    return result.toEntity();
  }

  @override
  Future<Review> updateReview(String token, String reviewId,
      {int? rating, List<String>? images, String? review, bool? anonymous}) {
    // TODO: implement updateReview
    throw UnimplementedError();
  }

  @override
  Future<List<Review>> getBuyerReviews(String token) async {
    try {
      final results = await remoteDataSource.getBuyerReviews(token);

      return List<Review>.from(results.map((e) => e.toEntity()));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Review>> getProductReviews(String productId) async {
    try {
      final results = await remoteDataSource.getProductReviews(productId);

      return List<Review>.from(results.map((e) => e.toEntity()));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Review>> getSellerReviews(String sellerId) async {
    try {
      final results = await remoteDataSource.getSellerReviews(sellerId);

      return List<Review>.from(results.map((e) => e.toEntity()));
    } catch (e) {
      rethrow;
    }
  }
}
