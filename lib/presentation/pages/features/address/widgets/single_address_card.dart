import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/presentation/helper_variables/future_function_handler.dart';
import 'package:tocopedia/presentation/pages/features/address/view_all_addresses_page.dart';
import 'package:tocopedia/presentation/pages/features/transaction/widgets/order_status_card.dart';
import 'package:tocopedia/presentation/providers/address_provider.dart';
import 'package:tocopedia/presentation/providers/user_provider.dart';

class SingleAddressCard extends StatelessWidget {
  final Address address;
  final bool isDefault;

  const SingleAddressCard(
      {Key? key, required this.address, this.isDefault = true})
      : super(key: key);

  Future<void> setAsDefault(BuildContext context) async {
    await handleFutureFunction(
      context,
      successMessage: "Address has been set as default",
      function: Provider.of<UserProvider>(context, listen: false)
          .updateUser(addressId: address.id),
    );
    if (context.mounted) {
      Navigator.of(context)
          .popUntil(ModalRoute.withName(ViewAllAddressesPage.routeName));
    }
  }

  Future<void> deleteAddress(BuildContext context) async {
    await handleFutureFunction(
      context,
      loadingMessage: "Deleting address",
      successMessage: "Address deleted successfully",
      function: Provider.of<AddressProvider>(context, listen: false)
          .deleteAddress(address.id!),
    );
    if (context.mounted) {
      Navigator.of(context)
          .popUntil(ModalRoute.withName(ViewAllAddressesPage.routeName));
    }
  }

  void showOtherMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
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
                  Text("Other Actions",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold))
                ],
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () => setAsDefault(context),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          "Set as Default Address",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(indent: 5, endIndent: 5),
              GestureDetector(
                onTap: () => deleteAddress(context),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Text(
                          "Delete Address",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isDefault
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withOpacity(0.5),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      color: isDefault
          ? theme.colorScheme.secondaryContainer.withOpacity(.25)
          : null,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(4)),
                    color: theme.primaryColor,
                  ),
                  width: 5,
                  height: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  address.label!,
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                if (isDefault)
                  const OrderStatusCard(text: "Default", color: Colors.green),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15).copyWith(bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address.receiverName!,
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(address.receiverPhone!),
                Text(address.completeAddress!),
                if (address.notes != null) Text("(${address.notes})"),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () {},
                            child: const Text("Change Address"))),
                    const SizedBox(width: 5),
                    if (!isDefault)
                      OutlinedButton(
                          onPressed: () => showOtherMenu(context),
                          child: const Icon(Icons.more_horiz)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
