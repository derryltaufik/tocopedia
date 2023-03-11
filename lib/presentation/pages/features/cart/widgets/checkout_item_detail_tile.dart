
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tocopedia/presentation/helper_variables/format_rupiah.dart';
import 'package:tocopedia/domains/entities/cart_item_detail.dart';

class CheckoutItemDetailTile extends StatelessWidget {
  final CartItemDetail cartItemDetail;

  const CheckoutItemDetailTile({
    Key? key,
    required this.cartItemDetail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = cartItemDetail.product;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 75,
          height: 75,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: CachedNetworkImage(
              imageUrl: product!.images![0],
              fit: BoxFit.cover,
              progressIndicatorBuilder: (_, __, downloadProgress) => Center(
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress)),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name!,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                "${cartItemDetail.quantity!} item(s)",
                style:
                    theme.textTheme.bodySmall!.copyWith(color: Colors.black54),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                rupiahFormatter.format(product.price),
                style: theme.textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NumericalRangeFormatter extends TextInputFormatter {
  final int min;
  final int max;

  NumericalRangeFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text == '' || int.parse(newValue.text) < min) {
      // String newText = min.toStringAsFixed(0);
      // return const TextEditingValue().copyWith(
      //     text: newText,
      //     selection:
      //         TextSelection.fromPosition(TextPosition(offset: newText.length)));
      // //if > product stock, set to product stock
    } else {
      String newText = max.toStringAsFixed(0);

      return int.parse(newValue.text) > max
          ? const TextEditingValue().copyWith(
              text: newText,
              selection: TextSelection.fromPosition(
                  TextPosition(offset: newText.length)))
          : newValue;
    }
    return newValue;
  }
}
