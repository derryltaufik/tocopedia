import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/domains/repositories/address_repository.dart';

class DeleteAddress {
  final AddressRepository repository;

  DeleteAddress(this.repository);

  Future<Address> execute(String token, String addressId) {
    return repository.deleteAddress(
      token,
      addressId,
    );
  }
}
