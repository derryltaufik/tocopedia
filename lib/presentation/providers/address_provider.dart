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

  Future<List<Address>> getUserAddresses() async {
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
      _message = e.toString();
      _getUserAddressesState = ProviderState.error;
      notifyListeners();
      rethrow;
    }
  }

  bool _verifyToken() {
    return (_authToken != null && _authToken!.isNotEmpty);
  }
}
