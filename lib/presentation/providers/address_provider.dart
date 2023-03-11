import 'package:flutter/material.dart';
import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/domains/use_cases/address/add_address.dart';
import 'package:tocopedia/domains/use_cases/address/delete_address.dart';
import 'package:tocopedia/domains/use_cases/address/get_address.dart';
import 'package:tocopedia/domains/use_cases/address/get_user_addresses.dart';
import 'package:tocopedia/domains/use_cases/address/update_address.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';

class AddressProvider with ChangeNotifier {
  final AddAddress _addAddress;
  final UpdateAddress _updateAddress;
  final GetUserAddresses _getUserAddresses;
  final GetAddress _getAddress;
  final DeleteAddress _deleteAddress;
  final String? _authToken;

  String _message = "";

  String get message => _message;

  List<Address>? addressesList;

  ProviderState _getUserAddressesState = ProviderState.empty;

  ProviderState get getUserAddressesState => _getUserAddressesState;

  AddressProvider(
      {required AddAddress addAddress,
      required UpdateAddress updateAddress,
      required GetUserAddresses getUserAddresses,
      required GetAddress getAddress,
      required DeleteAddress deleteAddress,
      required String? authToken})
      : _addAddress = addAddress,
        _updateAddress = updateAddress,
        _getAddress = getAddress,
        _getUserAddresses = getUserAddresses,
        _deleteAddress = deleteAddress,
        _authToken = authToken;

  Future<List<Address>?> getUserAddresses() async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      _getUserAddressesState = ProviderState.loading;
      notifyListeners();

      final addresses = await _getUserAddresses.execute(_authToken!);
      addressesList = addresses;
      _getUserAddressesState = ProviderState.loaded;
      notifyListeners();

      return addresses;
    } catch (e) {
      _message = e.toString();
      _getUserAddressesState = ProviderState.error;
      notifyListeners();
      return null;
    }
  }

  Future<Address> addAddress({
    String? label,
    required String completeAddress,
    String? notes,
    required String receiverName,
    required String receiverPhone,
  }) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      final address = await _addAddress.execute(
        _authToken!,
        receiverPhone: receiverPhone,
        receiverName: receiverName,
        completeAddress: completeAddress,
        label: label,
        notes: notes,
      );
      addressesList?.add(address);
      notifyListeners();
      return address;
    } catch (e) {
      _message = e.toString();
      rethrow;
    }
  }

  Future<Address> updateAddress(
    String addressId, {
    String? label,
    required String completeAddress,
    String? notes,
    required String receiverName,
    required String receiverPhone,
  }) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      final address = await _updateAddress.execute(
        _authToken!,
        addressId,
        receiverPhone: receiverPhone,
        receiverName: receiverName,
        completeAddress: completeAddress,
        label: label,
        notes: notes,
      );
      final index =
          addressesList?.indexWhere((element) => element.id! == addressId);
      if (index != null && index != -1) addressesList?[index] = address;

      notifyListeners();
      return address;
    } catch (e) {
      _message = e.toString();
      rethrow;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      if (!_verifyToken()) throw Exception("You need to login");
      await _deleteAddress.execute(_authToken!, addressId);
      addressesList?.removeWhere((element) => element.id == addressId);
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      rethrow;
    }
  }

  bool _verifyToken() {
    return (_authToken != null && _authToken!.isNotEmpty);
  }
}
