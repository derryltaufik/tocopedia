import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/features/seller_product/seller_add_product_page.dart';

class SellerViewAllProductsPage extends StatelessWidget {
  const SellerViewAllProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products  📦"),
        actions: [
          TextButton.icon(
              onPressed: () => Navigator.of(context)
                  .pushNamed(SellerAddProductPage.routeName),
              label: Icon(Icons.add),
              icon: Text("Add Product"))
        ],
      ),
    );
  }
}
