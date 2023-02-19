class Category {
  Category({
    required this.name,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? name;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
}
