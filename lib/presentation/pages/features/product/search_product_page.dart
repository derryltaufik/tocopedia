import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/presentation/pages/common_widgets/home_appbar.dart';
import 'package:tocopedia/presentation/pages/features/product/widgets/single_product_card.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';
import 'package:tocopedia/presentation/providers/provider_state.dart';

class SearchProductPage extends StatefulWidget {
  static const routeName = "/products/search";

  final String searchQuery;

  const SearchProductPage({
    super.key,
    required this.searchQuery,
  });

  @override
  State<SearchProductPage> createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false)
          .searchProduct(query: widget.searchQuery);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: HomeAppBar(query: widget.searchQuery),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search results for: \"${widget.searchQuery}\"",
              style: theme.textTheme.titleMedium,
            ),
            Flexible(
              child: Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                if (productProvider.searchProductState ==
                    ProviderState.loading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (productProvider.searchProductState == ProviderState.error) {
                  return Center(child: Text(productProvider.message));
                }

                final products = productProvider.searchedProduct!;

                if (products.isEmpty) {
                  return Center(
                      child: Text("Product not found... Try another keyword"));
                }

                return MasonryGridView.count(
                  crossAxisCount: 2,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final Product product = products[index];
                    return SingleProductCard(product: product);
                  },
                );
              }),
            )
          ],
        ),
      ),
      floatingActionButton: FilledButton.icon(
        onPressed: () {},
        icon: Icon(Icons.filter_alt_outlined),
        label: Text("Sort & Filter"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
