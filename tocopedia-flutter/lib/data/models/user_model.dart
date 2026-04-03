import 'dart:convert';

import 'package:tocopedia/data/models/address_model.dart';
import 'package:tocopedia/domains/entities/user.dart';

class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final AddressModel? defaultAddress;
  final String? token;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      password: password,
      createdAt: createdAt,
      defaultAddress: defaultAddress?.toEntity(),
      token: token,
      updatedAt: updatedAt,
      v: v,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      token: user.token,
      updatedAt: user.updatedAt,
      createdAt: user.createdAt,
      v: user.v,
      name: user.name,
      password: user.password,
      email: user.email,
      defaultAddress: user.defaultAddress == null
          ? null
          : AddressModel.fromEntity(user.defaultAddress!),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

//<editor-fold desc="Data Methods">
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.defaultAddress,
    required this.token,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          password == other.password &&
          defaultAddress == other.defaultAddress &&
          token == other.token &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          v == other.v);

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      defaultAddress.hashCode ^
      token.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      v.hashCode;

  @override
  String toString() {
    return 'UserModel{ id: $id, name: $name, email: $email, password: $password, defaultAddress: $defaultAddress, token: $token, createdAt: $createdAt, updatedAt: $updatedAt, v: $v,}';
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    AddressModel? defaultAddress,
    String? token,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      defaultAddress: defaultAddress ?? this.defaultAddress,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'defaultAddress': defaultAddress,
      'token': token,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'v': v,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      defaultAddress: map['default_address'] == null
          ? null
          : AddressModel.fromMap(map['default_address']),
      token: map['token'] ?? "",
      createdAt:
          map['createdAt'] == null ? null : DateTime.parse(map['createdAt']),
      updatedAt:
          map['updatedAt'] == null ? null : DateTime.parse(map['updatedAt']),
      v: map['__v'],
    );
  }

//</editor-fold>
}
