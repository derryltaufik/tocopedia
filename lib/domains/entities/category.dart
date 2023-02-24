class Category {
  Category({
    required this.name,
    required this.id,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? name;
  final String? id;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Category &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id &&
          image == other.image &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          v == other.v;

  @override
  int get hashCode =>
      name.hashCode ^
      id.hashCode ^
      image.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      v.hashCode;
}
