import 'package:tocopedia/domains/entities/address.dart';

abstract class AddressRepository {
  Future<Address> addAddress(
      String token, {
        String? label,
        required String completeAddress,
        String? notes,
        required String receiverName,
        required String receiverPhone,
      });

  Future<List<Address>> getUserAddresses(String token);

  Future<Address> getAddress(String token, String addressId);

  Future<Address> updateAddress(
      String token,
      String addressId, {
        String? label,
        String? completeAddress,
        String? notes,
        String? receiverName,
        String? receiverPhone,
      });

  Future<Address> deleteAddress(String token, String addressId);

}
