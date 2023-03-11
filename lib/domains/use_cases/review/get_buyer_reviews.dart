import 'package:tocopedia/domains/entities/review.dart';
import 'package:tocopedia/domains/repositories/review_repository.dart';

class GetBuyerReviews {
  final ReviewRepository repository;

  GetBuyerReviews(this.repository);

  Future<List<Review>> execute(String token) {
    return repository.getBuyerReviews(token);
  }
}
