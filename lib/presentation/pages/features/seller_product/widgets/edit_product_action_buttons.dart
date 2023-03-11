import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/presentation/helper_variables/future_function_handler.dart';
import 'package:tocopedia/presentation/pages/common_widgets/custom_form_field.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';
import 'package:tocopedia/presentation/pages/features/product/view_product_page.dart';

class EditProductActionButtons extends StatelessWidget {
  final Product product;

  const EditProductActionButtons({
    super.key,
    required this.product,
  });

  Future<void> delete(BuildContext context) async {
    final bool? deleteProduct = await showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete this product?"),
        content: const Text("CAUTION! Deleted product can not be recovered."),
        actions: [
          OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("NO")),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text("YES")),
        ],
      ),
    );

    if (deleteProduct != null && deleteProduct == true && context.mounted) {
      handleFutureFunction(context,
          loadingMessage: "Deleting product...",
          successMessage: "Product deleted",
          function: Provider.of<ProductProvider>(context, listen: false)
              .deleteProduct(product.id!));
    }
  }

  Future<void> changePrice(BuildContext context) async {
    final price = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          ChangePriceBottomSheet(initialPrice: product.price!),
    );

    if (price != null && context.mounted) {
      handleFutureFunction(context,
          loadingMessage: "Updating price...",
          successMessage: "Price updated",
          function: Provider.of<ProductProvider>(context, listen: false)
              .updateProduct(product.id!, price: price));
    }
  }

  Future<void> changeStock(BuildContext context) async {
    final temp = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => ChangeStockBottomSheet(
          initialActive: product.status == "active",
          initialStock: product.stock ?? 1),
    );
    //use deconstruct if possible
    final stock = temp?["stock"];
    final active = temp?["active"];

    if ((stock != null && stock is int) &&
        (active != null && active is bool) &&
        context.mounted) {
      handleFutureFunction(context,
          loadingMessage: "Updating stock...",
          successMessage: "Stock updated",
          function: Provider.of<ProductProvider>(context, listen: false)
              .updateProduct(product.id!, stock: stock, active: active));
    }
  }

  void showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ShowMoreOptionsBottomSheet(
        onView: () => Navigator.of(context)
            .popAndPushNamed(ViewProductPage.routeName, arguments: product.id!),
        onDelete: () => delete(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    minimumSize: Size.zero),
                onPressed: () => changePrice(context),
                child: const Text("Change Price"))),
        const SizedBox(width: 10),
        Expanded(
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    minimumSize: Size.zero),
                onPressed: () => changeStock(context),
                child: const Text("Change Stock"))),
        IconButton(
          onPressed: () => showMoreOptions(context),
          icon: const Icon(Icons.more_vert_rounded),
        ),
      ],
    );
  }
}

class ChangePriceBottomSheet extends StatefulWidget {
  final int initialPrice;

  const ChangePriceBottomSheet({Key? key, required this.initialPrice})
      : super(key: key);

  @override
  State<ChangePriceBottomSheet> createState() => _ChangePriceBottomSheetState();
}

class _ChangePriceBottomSheetState extends State<ChangePriceBottomSheet> {
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _priceController.text =
        RupiahInputFormatter().format(widget.initialPrice.toString());
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0)
          .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded)),
              Text("Modify Price", style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 10),
          CustomTextField.rupiah(
            controller: _priceController,
            autoFocus: true,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () =>
                      Navigator.of(context).pop(_priceController.getInt()),
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ChangeStockBottomSheet extends StatefulWidget {
  final bool initialActive;
  final int initialStock;

  const ChangeStockBottomSheet(
      {Key? key, required this.initialActive, required this.initialStock})
      : super(key: key);

  @override
  State<ChangeStockBottomSheet> createState() => _ChangeStockBottomSheetState();
}

class _ChangeStockBottomSheetState extends State<ChangeStockBottomSheet> {
  late bool active;

  final _stockController = TextEditingController();

  @override
  void initState() {
    super.initState();
    active = widget.initialActive;
    _stockController.text = widget.initialStock.toString();
  }

  @override
  void dispose() {
    _stockController.dispose();
    super.dispose();
  }

  void increase() {
    updateStock(_stockController.getInt()! + 1);
  }

  void decrease() {
    updateStock(_stockController.getInt()! - 1);
  }

  void updateStock(int stock) {
    setState(() {
      _stockController.text = stock.toString();
      _stockController.selection =
          TextSelection.collapsed(offset: _stockController.text.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0)
          .copyWith(bottom: MediaQuery.of(context).viewInsets.bottom + 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.close_rounded)),
              Text("Modify Stock", style: theme.textTheme.titleMedium),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Active Product", style: theme.textTheme.titleSmall),
              Switch(
                value: active,
                onChanged: (value) => setState(() => active = value),
              )
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Stock", style: theme.textTheme.titleSmall),
              const Spacer(),
              QuantityField(
                controller: _stockController,
                minimum: 0,
                maximum: 999999,
                onIncrease: () => increase(),
                onDecrease: () => decrease(),
                autoFocus: true,
                width: 50,
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(
                      {"stock": _stockController.getInt()!, "active": active}),
                  child: const Text("Save"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ShowMoreOptionsBottomSheet extends StatelessWidget {
  final void Function()? onView;
  final void Function()? onDelete;

  const ShowMoreOptionsBottomSheet({Key? key, this.onView, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, size: 30),
              ),
              const SizedBox(width: 5),
              Text("Manage",
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.bold))
            ],
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onView,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  const Icon(Icons.visibility_outlined),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text("View Product",
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  const Icon(Icons.delete_outline_rounded),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text("Delete Product",
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
