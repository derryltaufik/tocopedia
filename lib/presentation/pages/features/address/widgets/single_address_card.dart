import 'package:flutter/material.dart';
import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/presentation/pages/features/transaction/widgets/order_status_card.dart';

class SingleAddressCard extends StatelessWidget {
  final Address address;
  final bool isDefault;

  const SingleAddressCard(
      {Key? key, required this.address, this.isDefault = true})
      : super(key: key);

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
                    borderRadius:
                        BorderRadius.horizontal(right: Radius.circular(4)),
                    color: theme.primaryColor,
                  ),
                  width: 5,
                  height: 18,
                ),
                SizedBox(width: 10),
                Text(
                  address.label!,
                  style: theme.textTheme.labelLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                if (isDefault)
                  OrderStatusCard(text: "Default", color: Colors.green),
              ],
            ),
          ),
          SizedBox(height: 2),
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
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                        child: OutlinedButton(
                            onPressed: () {}, child: Text("Change Address"))),
                    SizedBox(width: 5),
                    OutlinedButton(
                        onPressed: () {}, child: Icon(Icons.more_horiz)),
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
