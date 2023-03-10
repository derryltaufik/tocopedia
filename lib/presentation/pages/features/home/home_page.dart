import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/presentation/pages/common_widgets/home_appbar.dart';
import 'package:tocopedia/presentation/pages/features/home/widgets/category_button.dart';
import 'package:tocopedia/presentation/pages/features/product/widgets/single_product_card.dart';
import 'package:tocopedia/presentation/providers/category_provider.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';

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
      if (Provider.of<ProductProvider>(context, listen: false)
                  .getPopularProductsState !=
              ProviderState.loaded ||
          Provider.of<CategoryProvider>(context, listen: false)
                  .getAllCategoriesState !=
              ProviderState.loaded) {
        _fetchData(context);
      }
    });
  }

  Future<void> _fetchData(BuildContext context) async {
    Provider.of<ProductProvider>(context, listen: false).getPopularProducts();
    Provider.of<CategoryProvider>(context, listen: false).getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: () => _fetchData(context),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Browse By Category",
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 140.0,
                child: Consumer<CategoryProvider>(
                    builder: (context, categoryProvider, child) {
                  if (categoryProvider.getAllCategoriesState ==
                      ProviderState.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (categoryProvider.getAllCategoriesState ==
                      ProviderState.error) {
                    return Center(child: Text(categoryProvider.message));
                  }

                  final categories = categoryProvider.allCategories;

                  if (categories == null || categories.isEmpty) {
                    return const Center(child: Text("Categories not found..."));
                  }

                  return GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.25,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryButton(category: category);
                    },
                  );
                }),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(10),
              sliver: SliverToBoxAdapter(
                child: Text(
                  "Popular Products",
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: Consumer<ProductProvider>(
                  builder: (context, productProvider, child) {
                if (productProvider.getPopularProductsState ==
                    ProviderState.loading) {
                  return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()));
                }
                if (productProvider.getPopularProductsState ==
                    ProviderState.error) {
                  return SliverFillRemaining(
                      child: Center(child: Text(productProvider.message)));
                }

                final products = productProvider.popularProducts;

                if (products == null || products.isEmpty) {
                  return const SliverFillRemaining(
                      child: Center(child: Text("Product not found... ")));
                }

                return SliverMasonryGrid(
                  delegate: SliverChildBuilderDelegate(
                      childCount: products.length, (context, index) {
                    final Product product = products[index];
                    return SingleProductCard(product: product);
                  }),
                  gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
