import 'package:tocopedia/domains/entities/user.dart';

class Address {
  Address({
    required this.id,
    required this.owner,
    required this.label,
    required this.completeAddress,
    required this.notes,
    required this.receiverName,
    required this.receiverPhone,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final User? owner;
  final String? label;
  final String? completeAddress;
  final String? notes;
  final String? receiverName;
  final String? receiverPhone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
}
