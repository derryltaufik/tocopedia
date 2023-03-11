import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/cart_item.dart';
import 'package:tocopedia/presentation/pages/features/cart/widgets/cart_item_detail_tile.dart';
import 'package:tocopedia/presentation/providers/cart_provider.dart';

class ShopCheckboxNotifier extends ValueNotifier<bool> {
  ShopCheckboxNotifier(super.value);

  void setValue(bool value) {
    this.value = value;
    notifyListeners();
  }
}

class CartItemTile extends StatefulWidget {
  final CartItem cartItem;

  const CartItemTile({Key? key, required this.cartItem}) : super(key: key);

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  late final ShopCheckboxNotifier _shopCheckboxNotifier;
  final Map<String, bool> childrenValues =
      {}; //to keep track all children checkbox states

  late bool checked;

  @override
  void initState() {
    super.initState();

    //set initial checkbox state by checking each child
    bool foundFalse = false;
    for (var element in widget.cartItem.cartItemDetails!) {
      childrenValues[element.id!] = element.selected!;
      if (element.selected! == false) foundFalse = true;
    }
    if (foundFalse) {
      _shopCheckboxNotifier = ShopCheckboxNotifier(false);
      checked = false;
    } else {
      _shopCheckboxNotifier = ShopCheckboxNotifier(true);
      checked = true;
    }
  }

  @override
  void dispose() {
    _shopCheckboxNotifier.dispose();
    super.dispose();
  }

  void toggleSeller(BuildContext context, bool value) async {
    setState(() {
      checked = value;
    });
    _shopCheckboxNotifier.setValue(value);
    childrenValues.updateAll((_, __) => value);

    if (value) {
      await Provider.of<CartProvider>(context, listen: false)
          .selectSeller(widget.cartItem.seller!.id!);
    } else {
      await Provider.of<CartProvider>(context, listen: false)
          .unselectSeller(widget.cartItem.seller!.id!);
    }
  }

  void _updateCheckboxState(String cartItemId, bool value) {
    childrenValues[cartItemId] = value;

    bool newState = false;
    if (!childrenValues.containsValue(false)) {
      newState = true;
    }

    setState(() => checked = newState);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)),
              value: checked,
              onChanged: (value) => toggleSeller(context, value!),
            ),
            Text(
              "${widget.cartItem.seller!.name!} Store",
              style: Theme.of(context).textTheme.titleSmall,
            )
          ],
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => const Divider(thickness: 0),
          itemCount: widget.cartItem.cartItemDetails!.length,
          itemBuilder: (context, index) {
            final cartItemDetail = widget.cartItem.cartItemDetails![index];
            return CartItemDetailTile(
              updateCheckBoxState: _updateCheckboxState,
              checkBoxNotifier: _shopCheckboxNotifier,
              cartItemDetail: cartItemDetail,
              key: Key(cartItemDetail.id!),
            );
          },
        )
      ],
    );
  }
}
