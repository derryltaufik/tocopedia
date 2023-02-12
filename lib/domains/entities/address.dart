class Address {
  Address({
    required this.id,
    required this.ownerId,
    required this.label,
    required this.completeAddress,
    this.notes,
    required this.receiverName,
    required this.receiverPhone,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String id;
  final String ownerId;
  final String label;
  final String completeAddress;
  String? notes;
  final String receiverName;
  final String receiverPhone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
}
