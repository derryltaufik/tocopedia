import 'dart:convert';

import 'package:tocopedia/domains/entities/address.dart';

class AddressModel {
  final String id;
  final String ownerId;
  final String label;
  final String completeAddress;
  final String? notes;
  final String receiverName;
  final String receiverPhone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

//<editor-fold desc="Data Methods">
  const AddressModel({
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AddressModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          ownerId == other.ownerId &&
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
      ownerId.hashCode ^
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
    return 'AddressModel{ id: $id, ownerId: $ownerId, label: $label, completeAddress: $completeAddress, notes: $notes, receiverName: $receiverName, receiverPhone: $receiverPhone, createdAt: $createdAt, updatedAt: $updatedAt, v: $v,}';
  }

  AddressModel copyWith({
    String? id,
    String? ownerId,
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
      ownerId: ownerId ?? this.ownerId,
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
      'owner_id': ownerId,
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
      id: map['_id'] as String,
      ownerId: map['owner_id'] as String,
      label: map['label'] as String,
      completeAddress: map['complete_address'] as String,
      notes: map['notes'],
      receiverName: map['receiver_name'] as String,
      receiverPhone: map['receiver_phone'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      v: map['__v'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressModel.fromJson(String source) =>
      AddressModel.fromMap(json.decode(source));

  Address toEntity() {
    return Address(
      id: id,
      ownerId: ownerId,
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
      ownerId: address.ownerId,
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
