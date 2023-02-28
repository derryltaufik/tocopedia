import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
import 'package:tocopedia/presentation/pages/features/address/add_address_page.dart';
import 'package:tocopedia/presentation/pages/features/address/widgets/single_address_card.dart';
import 'package:tocopedia/presentation/providers/address_provider.dart';
import 'package:tocopedia/presentation/providers/user_provider.dart';

class ViewAllAddressesPage extends StatefulWidget {
  static const String routeName = "/addresses/view-all";

  const ViewAllAddressesPage({Key? key}) : super(key: key);

  @override
  State<ViewAllAddressesPage> createState() => _ViewAllAddressesPageState();
}

class _ViewAllAddressesPageState extends State<ViewAllAddressesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AddressProvider>(context, listen: false).getUserAddresses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Addresses List"),
        actions: [
          TextButton(
            child: const Text("Add Address"),
            onPressed: () =>
                Navigator.of(context).pushNamed(AddAddressPage.routeName),
          )
        ],
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          if (addressProvider.getUserAddressesState == ProviderState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (addressProvider.getUserAddressesState == ProviderState.error) {
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

          return ListView.separated(
            padding:
                const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 15),
            separatorBuilder: (context, index) => const SizedBox(height: 15),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final Address address = addresses[index];
              return SingleAddressCard(
                address: address,
                isDefault: address.id! == defaultAddressId,
              );
            },
          );
        },
      ),
    );
  }
}