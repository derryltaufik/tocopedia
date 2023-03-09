import 'dart:io';

import 'package:tocopedia/domains/entities/review.dart';
import 'package:tocopedia/domains/repositories/review_repository.dart';

class UpdateReview {
  final ReviewRepository repository;

  UpdateReview(this.repository);

  Future<Review> execute(
    String token,
    String reviewId, {
    int? rating,
    List<File>? newImages,
    List<String>? oldImages,
    String? review,
    bool? anonymous,
  }) {
    return repository.updateReview(
      token,
      reviewId,
      rating: rating,
      anonymous: anonymous,
      oldImages: oldImages,
      newImages: newImages,
      review: review,
    );
  }
}
