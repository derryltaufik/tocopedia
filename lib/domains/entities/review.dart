
class Review {
  Review({
    required this.id,
    required this.orderItemId,
    required this.buyerId,
    required this.productId,
    required this.rating,
    required this.images,
    required this.review,
    required this.anonymous,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String id;
  final String orderItemId;
  final String buyerId;
  final String productId;
  final int rating;
  final List<String> images;
  final String review;
  final bool anonymous;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

}