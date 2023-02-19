import 'dart:convert';

import 'package:tocopedia/domains/entities/category.dart';

class CategoryModel {
  final String? name;
  final String? id;
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
      createdAt: createdAt,
      updatedAt: updatedAt,
      v: v,
    );
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
      v: category.v,
    );
  }

//<editor-fold desc="Data Methods">
  const CategoryModel({
    required this.name,
    required this.id,
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
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          v == other.v);

  @override
  int get hashCode =>
      name.hashCode ^
      id.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      v.hashCode;

  @override
  String toString() {
    return 'CategoryModel{ name: $name, id: $id, createdAt: $createdAt, updatedAt: $updatedAt, v: $v,}';
  }

  CategoryModel copyWith({
    String? name,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'v': v,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      name: map['name'],
      id: map['_id'],
      createdAt:
          map['createdAt'] == null ? null : DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] == null ? null : DateTime.parse(map['updatedAt']),
      v: map['__v'],
    );
  }

//</editor-fold>
}
