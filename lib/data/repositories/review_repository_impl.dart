import 'package:tocopedia/data/data_sources/review_remote_data_source.dart';
import 'package:tocopedia/domains/entities/review.dart';

import 'package:tocopedia/domains/repositories/review_repository.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Review> addReview(String token, String orderItemId,
      {required int rating,
      List<String>? images,
      String? review,
      bool? anonymous}) {
    // TODO: implement addReview
    throw UnimplementedError();
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
