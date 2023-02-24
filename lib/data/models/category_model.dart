import 'dart:convert';

import 'package:tocopedia/domains/entities/category.dart';

class CategoryModel {
  final String? name;
  final String? id;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      image: image,
      createdAt: createdAt,
      updatedAt: updatedAt,
      v: v,
    );
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      image: category.image,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
      v: category.v,
    );
  }

//<editor-fold desc="Data Methods">

  const CategoryModel({
    required this.name,
    required this.id,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryModel &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id &&
          image == other.image &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          v == other.v);

  @override
  int get hashCode =>
      name.hashCode ^
      id.hashCode ^
      image.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      v.hashCode;

  @override
  String toString() {
    return 'CategoryModel{ name: $name, id: $id, image: $image, createdAt: $createdAt, updatedAt: $updatedAt, v: $v,}';
  }

  CategoryModel copyWith({
    String? name,
    String? id,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      id: id ?? this.id,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
        id: json["_id"],
        name: json["name"],
        image: json["image"],
        v: json["__v"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toMap() => {
        "_id": id,
        "name": name,
        "image": image,
        "__v": v,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };

//</editor-fold>
}
