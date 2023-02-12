import 'package:tocopedia/domains/entities/address.dart';

abstract class AddressRepository {
  Future<Address> addAddress();

  Future<Address> updateAddress();

  Future<Address> deleteAddress(String id);

  Future<Address> getAddress(String id);

}
