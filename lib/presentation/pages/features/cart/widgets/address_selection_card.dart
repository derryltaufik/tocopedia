import 'package:flutter/material.dart';
import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/presentation/pages/common_widgets/status_card.dart';

class AddressSelectionCard extends StatelessWidget {
  const AddressSelectionCard({
    Key? key,
    required this.address,
    this.isDefault = false,
    this.isSelected = true,
    this.width = 200,
  }) : super(key: key);

  final Address address;
  final bool isDefault;
  final bool isSelected;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: width,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.5),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        color: isSelected
            ? theme.colorScheme.secondaryContainer.withOpacity(.25)
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  Expanded(
                    child: Text(
                      address.label!,
                      style: theme.textTheme.labelLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isDefault)
                    const StatusCard(text: "Default", color: Colors.green),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Flexible(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15)
                        .copyWith(bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address.receiverName!,
                          style: theme.textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(address.receiverPhone!),
                        Text(address.completeAddress!,
                            style: theme.textTheme.bodySmall,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
                if (isSelected)
                  Flexible(
                    flex: 1,
                    child: Icon(
                      Icons.check,
                      color: theme.primaryColor,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
