import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/presentation/helper_variables/future_function_handler.dart';
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

    if (deleteProduct != null && deleteProduct == true) {
      if (context.mounted) {
        handleFutureFunction(context,
            loadingMessage: "Deleting product...",
            successMessage: "Product deleted",
            function: Provider.of<ProductProvider>(context, listen: false)
                .deleteProduct(product.id!));
      }
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
                onPressed: () {},
                child: Text("Change Price"))),
        SizedBox(width: 10),
        Expanded(
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    minimumSize: Size.zero),
                onPressed: () {},
                child: Text("Change Stock"))),
        IconButton(
            onPressed: () => delete(context),
            icon: Icon(Icons.delete_outline_rounded)),
      ],
    );
  }
}
