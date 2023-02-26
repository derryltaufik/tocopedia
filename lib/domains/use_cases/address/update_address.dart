import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/domains/repositories/address_repository.dart';

class UpdateAddress {
  final AddressRepository repository;

  UpdateAddress(this.repository);

  Future<Address> execute(
    String token,
    String addressId, {
    String? label,
    required String completeAddress,
    String? notes,
    required String receiverName,
    required String receiverPhone,
  }) {
    return repository.updateAddress(
      token,
      addressId,
      completeAddress: completeAddress,
      receiverName: receiverName,
      receiverPhone: receiverPhone,
      notes: notes,
      label: label,
    );
  }
}
