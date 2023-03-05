import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/presentation/helper_variables/future_function_handler.dart';
import 'package:tocopedia/presentation/pages/common_widgets/custom_form_field.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';

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
        title: Text("Delete this product?"),
        content: Text("CAUTION! Deleted product can not be recovered."),
        actions: [
          OutlinedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("NO")),
          FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("YES")),
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    minimumSize: Size.zero),
                onPressed: () => changePrice(context),
                child: Text("Change Price"))),
        SizedBox(width: 10),
        Expanded(
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    minimumSize: Size.zero),
                onPressed: () => changeStock(context),
                child: Text("Change Stock"))),
        IconButton(
            onPressed: () => delete(context),
            icon: Icon(Icons.delete_outline_rounded)),
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
                  icon: Icon(Icons.close_rounded)),
              Text("Modify Price", style: theme.textTheme.titleMedium),
            ],
          ),
          SizedBox(height: 10),
          CustomTextField.rupiah(
            controller: _priceController,
            autoFocus: true,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () =>
                      Navigator.of(context).pop(_priceController.getInt()),
                  child: Text("Save"),
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
                  icon: Icon(Icons.close_rounded)),
              Text("Modify Stock", style: theme.textTheme.titleMedium),
            ],
          ),
          SizedBox(height: 5),
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
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Stock", style: theme.textTheme.titleSmall),
              Spacer(),
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
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(
                      {"stock": _stockController.getInt()!, "active": active}),
                  child: Text("Save"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
