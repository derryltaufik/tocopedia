import 'dart:io';

import 'package:tocopedia/domains/entities/review.dart';
import 'package:tocopedia/domains/repositories/review_repository.dart';

class AddReview {
  final ReviewRepository repository;

  AddReview(this.repository);

  Future<Review> execute(String token, String orderItemDetailId,
      {required int rating,
      List<File>? images,
      String? review,
      bool? anonymous}) {
    return repository.addReview(token, orderItemDetailId,
        rating: rating, anonymous: anonymous, images: images, review: review);
  }
}
