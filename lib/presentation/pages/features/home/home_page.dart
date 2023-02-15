import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/presentation/pages/common_widgets/home_appbar.dart';
import 'package:tocopedia/presentation/pages/features/product/widgets/single_product_card.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';
import 'package:tocopedia/presentation/providers/provider_state.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false).getPopularProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: HomeAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0).copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Browse Popular Products",
              style: theme.textTheme.titleLarge,
            ),
            Flexible(
              child: Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                if (productProvider.getPopularProductsState ==
                    ProviderState.loading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (productProvider.getPopularProductsState ==
                    ProviderState.error) {
                  return Center(child: Text(productProvider.message));
                }

                final products = productProvider.popularProducts!;

                if (products.isEmpty) {
                  return Center(child: Text("Product not found... "));
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
    );
  }
}
