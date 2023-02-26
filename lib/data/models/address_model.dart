import 'dart:convert';

import 'package:tocopedia/data/models/user_model.dart';
import 'package:tocopedia/domains/entities/address.dart';

class AddressModel {
  final String? id;
  final UserModel? owner;
  final String? label;
  final String? completeAddress;
  final String? notes;
  final String? receiverName;
  final String? receiverPhone;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

//<editor-fold desc="Data Methods">
  const AddressModel({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AddressModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          owner == other.owner &&
          label == other.label &&
          completeAddress == other.completeAddress &&
          notes == other.notes &&
          receiverName == other.receiverName &&
          receiverPhone == other.receiverPhone &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt &&
          v == other.v);

  @override
  int get hashCode =>
      id.hashCode ^
      owner.hashCode ^
      label.hashCode ^
      completeAddress.hashCode ^
      notes.hashCode ^
      receiverName.hashCode ^
      receiverPhone.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode ^
      v.hashCode;

  @override
  String toString() {
    return 'AddressModel{ id: $id, owner: $owner, label: $label, completeAddress: $completeAddress, notes: $notes, receiverName: $receiverName, receiverPhone: $receiverPhone, createdAt: $createdAt, updatedAt: $updatedAt, v: $v,}';
  }

  AddressModel copyWith({
    String? id,
    UserModel? owner,
    String? label,
    String? completeAddress,
    String? notes,
    String? receiverName,
    String? receiverPhone,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return AddressModel(
      id: id ?? this.id,
      owner: owner ?? this.owner,
      label: label ?? this.label,
      completeAddress: completeAddress ?? this.completeAddress,
      notes: notes ?? this.notes,
      receiverName: receiverName ?? this.receiverName,
      receiverPhone: receiverPhone ?? this.receiverPhone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'owner': owner,
      'label': label,
      'complete_address': completeAddress,
      'notes': notes,
      'receiver_name': receiverName,
      'receiver_phone': receiverPhone,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['_id'],
      owner: map['owner'] == null ? null : UserModel.fromMap(map['owner']),
      label: map['label'],
      completeAddress: map['complete_address'],
      notes: map['notes'],
      receiverName: map['receiver_name'],
      receiverPhone: map['receiver_phone'],
      createdAt:
          map["createdAt"] == null ? null : DateTime.parse(map["createdAt"]),
      updatedAt:
          map["updatedAt"] == null ? null : DateTime.parse(map["updatedAt"]),
      v: map['__v'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source));

  Address toEntity() {
    return Address(
      id: id,
      owner: owner?.toEntity(),
      label: label,
      completeAddress: completeAddress,
      notes: notes,
      receiverName: receiverName,
      receiverPhone: receiverPhone,
      createdAt: createdAt,
      updatedAt: updatedAt,
      v: v,
    );
  }

  factory AddressModel.fromEntity(Address address) {
    return AddressModel(
      id: address.id,
      owner:
          address.owner == null ? null : UserModel.fromEntity(address.owner!),
      label: address.label,
      completeAddress: address.completeAddress,
      notes: address.notes,
      receiverName: address.receiverName,
      receiverPhone: address.receiverPhone,
      createdAt: address.createdAt,
      updatedAt: address.updatedAt,
      v: address.v,
    );
  }
//</editor-fold>
}
