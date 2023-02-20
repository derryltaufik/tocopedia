import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/cart_item.dart';
import 'package:tocopedia/presentation/pages/features/cart/widgets/cart_item_detail_tile.dart';
import 'package:tocopedia/presentation/providers/cart_provider.dart';

class CartItemTile extends StatefulWidget {
  final CartItem cartItem;

  const CartItemTile({Key? key, required this.cartItem}) : super(key: key);

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> with ChangeNotifier {
  late final ValueNotifier<bool> _shopCheckboxNotifier;
  final Map<String, bool> childrenValues = {};

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
      _shopCheckboxNotifier = ValueNotifier(false);
      checked = false;
    } else {
      _shopCheckboxNotifier = ValueNotifier(true);
      checked = true;
    }
  }

  @override
  void dispose() {
    _shopCheckboxNotifier.dispose();
    dispose();
    super.dispose();
  }

  void toggleSeller(BuildContext context, bool value) async {
    setState(() {
      checked = value;
    });
    _shopCheckboxNotifier.value = value;
    _shopCheckboxNotifier.notifyListeners();

    if (value) {
      await Provider.of<CartProvider>(context, listen: false)
          .selectSeller(widget.cartItem.seller!.id!);
    } else {
      await Provider.of<CartProvider>(context, listen: false)
          .unselectSeller(widget.cartItem.seller!.id!);
    }
  }

  void foo(String cartItemId, bool value) {
    childrenValues[cartItemId] = value;

    bool newState = false;
    print(childrenValues.entries);
    if (!childrenValues.containsValue(false) &&
        childrenValues.length == widget.cartItem.cartItemDetails!.length) {
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
        SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Divider(thickness: 0),
          itemCount: widget.cartItem.cartItemDetails!.length,
          itemBuilder: (context, index) {
            final cartItemDetail = widget.cartItem.cartItemDetails![index];
            return CartItemDetailTile(
              updateCheckBoxState: foo,
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
