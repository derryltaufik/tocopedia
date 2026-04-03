import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/domains/repositories/address_repository.dart';

class GetUserAddresses {
  final AddressRepository repository;

  GetUserAddresses(this.repository);

  Future<List<Address>> execute(String token) {
    return repository.getUserAddresses(
      token,
    );
  }
}
