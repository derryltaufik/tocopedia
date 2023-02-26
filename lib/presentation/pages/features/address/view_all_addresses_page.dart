import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
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
        title: Text("Addresses List"),
        actions: [
          TextButton(
            child: Text("Add Address"),
            onPressed: () {},
          )
        ],
      ),
      body: Consumer<AddressProvider>(
        builder: (context, addressProvider, child) {
          if (addressProvider.getUserAddressesState == ProviderState.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (addressProvider.getUserAddressesState == ProviderState.error) {
            return Center(child: Text(addressProvider.message));
          }

          final addresses = addressProvider.addressesList;

          if (addresses == null || addresses.isEmpty) {
            return Center(child: Text("You don't have any address."));
          }

          final defaultAddressId =
              Provider.of<UserProvider>(context, listen: false)
                  .user
                  ?.defaultAddress
                  ?.id;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 15),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final Address address = addresses[index];
                return SingleAddressCard(
                  address: address,
                  isDefault: address.id! == defaultAddressId,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
