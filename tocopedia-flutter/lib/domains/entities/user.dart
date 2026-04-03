import 'package:tocopedia/domains/entities/address.dart';

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.defaultAddress,
    required this.token,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final Address? defaultAddress;
  final String? token;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
}
