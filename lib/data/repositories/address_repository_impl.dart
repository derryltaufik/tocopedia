import 'package:tocopedia/data/data_sources/address_remote_data_source.dart';
import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/domains/repositories/address_repository.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;

  AddressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Address> addAddress(
    String token, {
    String? label,
    required String completeAddress,
    String? notes,
    required String receiverName,
    required String receiverPhone,
  }) async {
    try {
      final result = await remoteDataSource.addAddress(
        token,
        label: label,
        completeAddress: completeAddress,
        receiverName: receiverName,
        receiverPhone: receiverPhone,
        notes: notes,
      );
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Address> deleteAddress(String token, String addressId) async {
    try {
      final result = await remoteDataSource.deleteAddress(token, addressId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Address> getAddress(String token, String addressId) async {
    try {
      final result = await remoteDataSource.getAddress(token, addressId);
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Address>> getUserAddresses(String token) async {
    try {
      final results = await remoteDataSource.getUserAddresses(token);
      return List<Address>.from(results.map((e) => e.toEntity()));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Address> updateAddress(
    String token,
    String addressId, {
    String? label,
    String? completeAddress,
    String? notes,
    String? receiverName,
    String? receiverPhone,
  }) async {
    try {
      final result = await remoteDataSource.updateAddress(
        token,
        addressId,
        label: label,
        completeAddress: completeAddress,
        receiverName: receiverName,
        receiverPhone: receiverPhone,
        notes: notes,
      );
      return result.toEntity();
    } catch (e) {
      rethrow;
    }
  }
}
