import 'package:tocopedia/domains/entities/order_item_detail.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/domains/entities/user.dart';

class Review {
  Review({
    this.id,
    this.orderItemDetail,
    this.seller,
    this.buyer,
    this.product,
    this.images,
    this.anonymous,
    this.completed,
    this.totalUpdate,
    this.createdAt,
    this.updatedAt,
    this.productName,
    this.productImage,
    this.review,
    this.v,
    this.rating,
  });

  final String? id;
  final OrderItemDetail? orderItemDetail;
  final User? seller;
  final User? buyer;
  final Product? product;
  final List<String>? images;
  final bool? anonymous;
  final bool? completed;
  final int? totalUpdate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? productName;
  final String? productImage;
  final String? review;
  final int? v;
  final int? rating;
}
