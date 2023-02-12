import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/domains/repositories/address_repository.dart';

class GetAddress {
  final AddressRepository repository;

  GetAddress(this.repository);

  Future<Address> execute(String id) {
    return repository.getAddress(id);
  }
}
