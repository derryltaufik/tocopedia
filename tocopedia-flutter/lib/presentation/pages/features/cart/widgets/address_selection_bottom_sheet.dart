import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
import 'package:tocopedia/presentation/pages/features/cart/widgets/address_selection_card.dart';
import 'package:tocopedia/presentation/providers/address_provider.dart';
import 'package:tocopedia/presentation/providers/user_provider.dart';

Future<Address?> showAddressSelectionBottomSheet(BuildContext context,
    {required Address selectedAddress}) {
  return showModalBottomSheet<Address>(
    context: context,
    builder: (context) =>
        AddressSelectionBottomSheet(selectedAddress: selectedAddress),
  );
}

class AddressSelectionBottomSheet extends StatefulWidget {
  const AddressSelectionBottomSheet({
    super.key,
    required this.selectedAddress,
  });

  final Address selectedAddress;

  @override
  State<AddressSelectionBottomSheet> createState() =>
      _AddressSelectionBottomSheetState();
}

class _AddressSelectionBottomSheetState
    extends State<AddressSelectionBottomSheet> {
  Address? selectedAddress;

  @override
  void initState() {
    super.initState();
    final addressProvider =
        Provider.of<AddressProvider>(context, listen: false);

    if (addressProvider.getUserAddressesState != ProviderState.loaded) {
      Future.microtask(() {
        addressProvider.getUserAddresses();
      });
    }
    selectedAddress = widget.selectedAddress;
  }

  void applyFilter() {
    Navigator.of(context).pop(selectedAddress);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, size: 30),
              ),
              const SizedBox(width: 5),
              Text("Select Address",
                  style: theme
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold))
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 200,
            child: Consumer<AddressProvider>(
                builder: (context, addressProvider, child) {
              if (addressProvider.getUserAddressesState ==
                  ProviderState.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (addressProvider.getUserAddressesState ==
                  ProviderState.error) {
                return Center(child: Text(addressProvider.message));
              }

              final addresses = addressProvider.addressesList;

              if (addresses == null || addresses.isEmpty) {
                return const Center(child: Text("You don't have any address."));
              }

              final defaultAddressId =
                  Provider.of<UserProvider>(context, listen: false)
                      .user
                      ?.defaultAddress
                      ?.id;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pop(address),
                    child: AddressSelectionCard(
                      address: address,
                      isDefault: address.id == defaultAddressId,
                      isSelected: address.id == selectedAddress?.id,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
