import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
import 'package:tocopedia/presentation/pages/common_widgets/single_child_full_page_scroll_view.dart';
import 'package:tocopedia/presentation/pages/features/seller_product/seller_add_product_page.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';
import 'package:tocopedia/presentation/pages/features/seller_product/widgets/product_list_tile.dart';

class SellerViewAllProductsPage extends StatefulWidget {
  const SellerViewAllProductsPage({Key? key}) : super(key: key);

  @override
  State<SellerViewAllProductsPage> createState() =>
      _SellerViewAllProductsPageState();
}

class _SellerViewAllProductsPageState extends State<SellerViewAllProductsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (Provider.of<ProductProvider>(context, listen: false)
              .getUserProductsState !=
          ProviderState.loaded) {
        _fetchData(context);
      }
    });
  }

  Future<void> _fetchData(BuildContext context) async {
    Provider.of<ProductProvider>(context, listen: false).getUserProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products  📦"),
        actions: [
          TextButton.icon(
              onPressed: () => Navigator.of(context)
                  .pushNamed(SellerAddProductPage.routeName),
              label: const Icon(Icons.add),
              icon: const Text("Add Product"))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchData(context),
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            if (productProvider.getUserProductsState == ProviderState.loading) {
              return const SingleChildFullPageScrollView.loading();
            }
            if (productProvider.getUserProductsState == ProviderState.error) {
              return SingleChildFullPageScrollView(
                  child: Text(productProvider.message));
            }

            final products = productProvider.userProducts;

            if (products == null || products.isEmpty) {
              return const SingleChildFullPageScrollView(
                  child: Text("No product found. Start adding new product"));
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, index) =>
                  const Divider(height: 0, thickness: 6),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ProductListTile(product: product);
              },
            );
          },
        ),
      ),
    );
  }
}
