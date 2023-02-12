import 'dart:convert';

import 'package:tocopedia/data/models/category_model.dart';
import 'package:tocopedia/domains/entities/product.dart';

class ProductModel {
  final String id;
  final String ownerId;
  final String name;
  final List<String> images;
  final int price;
  final int stock;
  final String? sku;
  final String description;
  final String status;
  final CategoryModel category;
  final int totalSold;
  final int? totalRating;
  final double? averageRating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  Product toEntity() {
    return Product(
      id: id,
      ownerId: ownerId,
      name: name,
      images: images,
      price: price,
      stock: stock,
      sku: sku,
      description: description,
      status: status,
      category: category.toEntity(),
      totalSold: totalSold,
      totalRating: totalRating ?? totalRating,
      averageRating: averageRating ?? averageRating,
      createdAt: createdAt,
      updatedAt: updatedAt,
      v: v,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));

//<editor-fold desc="Data Methods">
  const ProductModel({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.images,
    required this.price,
    required this.stock,
    this.sku,
    required this.description,
    required this.status,
    required this.category,
    required this.totalSold,
    this.totalRating,
    this.averageRating,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          ownerId == other.ownerId &&
          name == other.name &&
          images == other.images &&
          price == other.price &&
          stock == other.stock &&
          sku == other.sku &&
          description == other.description &&
          status == other.status &&
          category == other.category &&
          totalSold == other.totalSold &&
          totalRating == other.totalRating &&
          averageRating == other.averageRating &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          v == other.v);

  @override
  int get hashCode =>
      id.hashCode ^
      ownerId.hashCode ^
      name.hashCode ^
      images.hashCode ^
      price.hashCode ^
      stock.hashCode ^
      sku.hashCode ^
      description.hashCode ^
      status.hashCode ^
      category.hashCode ^
      totalSold.hashCode ^
      totalRating.hashCode ^
      averageRating.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      v.hashCode;

  @override
  String toString() {
    return 'ProductModel{ id: $id, ownerId: $ownerId, name: $name, images: $images, price: $price, stock: $stock, sku: $sku, description: $description, status: $status, category: $category, totalSold: $totalSold, totalRating: $totalRating, averageRating: $averageRating, createdAt: $createdAt, updatedAt: $updatedAt, v: $v,}';
  }

  ProductModel copyWith({
    String? id,
    String? ownerId,
    String? name,
    List<String>? images,
    int? price,
    int? stock,
    String? sku,
    String? description,
    String? status,
    CategoryModel? category,
    int? totalSold,
    int? totalRating,
    double? averageRating,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return ProductModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      images: images ?? this.images,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      sku: sku ?? this.sku,
      description: description ?? this.description,
      status: status ?? this.status,
      category: category ?? this.category,
      totalSold: totalSold ?? this.totalSold,
      totalRating: totalRating ?? this.totalRating,
      averageRating: averageRating ?? this.averageRating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'images': images,
      'price': price,
      'stock': stock,
      'sku': sku,
      'description': description,
      'status': status,
      'category': category,
      'totalSold': totalSold,
      'totalRating': totalRating,
      'averageRating': averageRating,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'v': v,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['_id'] as String,
      ownerId: map['owner_id'] as String,
      name: map['name'] as String,
      images: List<String>.from(map['images'].map((x) => x)),
      price: map['price'] as int,
      stock: map['stock'] as int,
      sku: map['sku'],
      description: map['description'] as String,
      status: map['status'] as String,
      category: CategoryModel.fromMap(map['category']),
      totalSold: map['total_sold'] as int,
      totalRating: map['total_rating'],
      averageRating: map['average_rating'] == null
          ? null
          : map['average_rating']!.toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      v: map['__v'] as int,
    );
  }

//</editor-fold>
}
