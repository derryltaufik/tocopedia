import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/domains/repositories/address_repository.dart';

class AddAddress {
  final AddressRepository repository;

  AddAddress(this.repository);

  Future<Address> execute(
    String token, {
    String? label,
    required String completeAddress,
    String? notes,
    required String receiverName,
    required String receiverPhone,
  }) {
    return repository.addAddress(token,
        completeAddress: completeAddress,
        receiverName: receiverName,
        receiverPhone: receiverPhone,
        notes: notes,
        label: label);
  }
}
