import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/presentation/helper_variables/search_arguments.dart';
import 'package:tocopedia/presentation/pages/common_widgets/home_appbar.dart';
import 'package:tocopedia/presentation/pages/features/product/widgets/filter_bottom_sheet.dart';
import 'package:tocopedia/presentation/pages/features/product/widgets/single_product_card.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';

class SearchProductPage extends StatefulWidget {
  static const routeName = "/products/search";

  final SearchArguments searchArguments;

  const SearchProductPage({super.key, required this.searchArguments});

  @override
  State<SearchProductPage> createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  late SearchArguments _searchArguments;
  late final _searchProduct =
      Provider.of<ProductProvider>(context, listen: false).searchProduct;

  @override
  void initState() {
    super.initState();
    _searchArguments = widget.searchArguments;
  }

  Future<void> filter(BuildContext context) async {

    final searchArguments =
        await showFilterBottomSheet(context, _searchArguments);
    FocusManager.instance.primaryFocus
        ?.unfocus(); // to fix autofocused on search textfield https://github.com/flutter/flutter/issues/54277

    if (searchArguments != null) {
      setState(() {
        _searchArguments = searchArguments;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_searchArguments.toString());
    final theme = Theme.of(context);
    return Scaffold(
      appBar: HomeAppBar(query: widget.searchArguments.searchQuery ?? ""),
      body: Padding(
        padding: const EdgeInsets.all(10.0).copyWith(bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Search results for: \"${widget.searchArguments.searchQuery ?? ""}\"",
              style: theme.textTheme.titleMedium,
            ),
            Flexible(
              child: FutureBuilder(
                  future: _searchProduct(_searchArguments),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final products = snapshot.data!;

                      if (products.isEmpty) {
                        return Center(
                            child: Text(
                                "Product not found... Try another keyword"));
                      }

                      return MasonryGridView.count(
                        crossAxisCount: 2,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final Product product = products[index];
                          return SingleProductCard(product: product);
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('${snapshot.error}'));
                    }
                    return Center(child: CircularProgressIndicator());
                  }),
            )
          ],
        ),
      ),
      floatingActionButton: FilledButton.icon(
        onPressed: () => filter(context),
        icon: Icon(Icons.filter_alt_outlined),
        label: Text("Sort & Filter"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
