import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/domains/entities/cart_item.dart';
import 'package:tocopedia/presentation/providers/cart_provider.dart';

class CartItemTile extends StatefulWidget {
  final CartItem cartItem;

  const CartItemTile({Key? key, required this.cartItem}) : super(key: key);

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  bool loading = true;
  bool selected = true;
  final TextEditingController _quantityController = TextEditingController();
  final FocusNode _quantityFocus = FocusNode();
  int quantity = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      if (mounted) {
        setState(() {
          loading = false;
          selected = widget.cartItem.selected;
          quantity = widget.cartItem.quantity;
          _quantityController.text = quantity.toString();
        });
      }
    });
    _quantityFocus.addListener(_handleFocusChange);
  }

  //update quantity when unfocused
  void _handleFocusChange() {
    if (!_quantityFocus.hasFocus) {
      updateQuantity();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _quantityController.dispose();
    _quantityFocus.dispose();
  }

  // click + button
  void addToCart(BuildContext context) async {
    setState(() {
      quantity++;
      _quantityController.text = quantity.toStringAsFixed(0);
      _quantityController.selection =
          TextSelection.collapsed(offset: _quantityController.text.length);
    });
    updateCart(context);
  }

  // click - button
  void removeFromCart(BuildContext context) async {
    setState(() {
      quantity--;
      _quantityController.text = quantity.toStringAsFixed(0);
      _quantityController.selection =
          TextSelection.collapsed(offset: _quantityController.text.length);
    });
    updateCart(context);
  }

  // edit quantity directly
  void updateQuantity() {
    setState(() {
      quantity = max(int.tryParse(_quantityController.text) ?? 1, 1);

      _quantityController.text = quantity.toStringAsFixed(0);
      _quantityController.selection =
          TextSelection.collapsed(offset: _quantityController.text.length);
    });

    updateCart(context);
  }

  // run when clicking + or - button or when updating quantity manually
  void updateCart(BuildContext context) async {
    await Provider.of<CartProvider>(context, listen: false)
        .updateCart(widget.cartItem.product.id!, quantity);
  }

  void toggleCartItem(BuildContext context, bool value) async {
    setState(() => selected = value);
    if (value) {
      await Provider.of<CartProvider>(context, listen: false)
          .selectCartItem(widget.cartItem.product.id!);
    } else {
      await Provider.of<CartProvider>(context, listen: false)
          .unselectCartItem(widget.cartItem.product.id!);
    }
  }

  void deleteCartItem(BuildContext context) async {
    await Provider.of<CartProvider>(context, listen: false)
        .updateCart(widget.cartItem.product.id!, 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final product = widget.cartItem.product;

    if (loading || product == null) {
      return ListTile(
        title: Center(child: CircularProgressIndicator()),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3)),
              value: selected,
              onChanged: (value) => toggleCartItem(context, value!),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 75,
                    height: 75,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: product.images![0],
                        fit: BoxFit.cover,
                        progressIndicatorBuilder: (_, __, downloadProgress) =>
                            Center(
                                child: CircularProgressIndicator(
                                    value: downloadProgress.progress)),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name!,
                          style: theme.textTheme.bodyLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3),
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
              ),
            )
          ],
        ),
        SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(children: [
            Text("Move To Wishlist",
                style: theme.textTheme.bodyMedium!
                    .copyWith(color: Colors.black54)),
            Spacer(),
            IconButton(
              onPressed: () => deleteCartItem(context),
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Colors.black54,
              ),
              iconSize: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black54, width: 0.5),
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              child: Row(
                children: [
                  AbsorbPointer(
                    absorbing:
                        int.parse(_quantityController.text) > 1 ? false : true,
                    child: GestureDetector(
                      onTap: () => removeFromCart(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2)
                            .copyWith(right: 0),
                        child: Icon(Icons.remove,
                            color: int.parse(_quantityController.text) > 1
                                ? theme.primaryColor
                                : Colors.black12),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 25,
                    child: TextField(
                      focusNode: _quantityFocus,
                      textAlign: TextAlign.center,
                      decoration: null,
                      style: theme.textTheme.bodySmall,
                      keyboardType: TextInputType.number,
                      controller: _quantityController,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        NumericalRangeFormatter(min: 1, max: product.stock!)
                      ],
                    ),
                  ),
                  // Text("${widget.cartItem.quantity}"),
                  AbsorbPointer(
                    absorbing:
                        int.parse(_quantityController.text) < product.stock!
                            ? false
                            : true,
                    child: GestureDetector(
                      onTap: () => addToCart(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2)
                            .copyWith(left: 0),
                        child: Icon(Icons.add,
                            color: int.parse(_quantityController.text) <
                                    product.stock!
                                ? theme.primaryColor
                                : Colors.black12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        )
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
