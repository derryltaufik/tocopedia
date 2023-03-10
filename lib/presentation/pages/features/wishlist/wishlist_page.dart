import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
import 'package:tocopedia/presentation/pages/common_widgets/cart_button_appbar.dart';
import 'package:tocopedia/presentation/pages/common_widgets/single_child_full_page_scroll_view.dart';
import 'package:tocopedia/presentation/pages/features/product/widgets/single_product_card.dart';
import 'package:tocopedia/presentation/providers/wishlist_provider.dart';

class WishListPage extends StatefulWidget {
  const WishListPage({Key? key}) : super(key: key);

  @override
  State<WishListPage> createState() => _WishListPageState();
}

class _WishListPageState extends State<WishListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (Provider.of<WishlistProvider>(context, listen: false)
              .getWishlistState !=
          ProviderState.loaded) {
        _fetchData(context);
      }
    });
  }

  Future<void> _fetchData(BuildContext context) async {
    Provider.of<WishlistProvider>(context, listen: false).getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CartButtonAppBar(title: "My Wishlist ❤️"),
      body: RefreshIndicator(
        onRefresh: () => _fetchData(context),
        child: Consumer<WishlistProvider>(
          builder: (context, wishlistProvider, child) {
            if (wishlistProvider.getWishlistState == ProviderState.loading) {
              return const SingleChildFullPageScrollView.loading();
            }
            if (wishlistProvider.getWishlistState == ProviderState.error) {
              return SingleChildFullPageScrollView(
                  child: Text(wishlistProvider.message));
            }

            final products = wishlistProvider.wishlist?.wishlistProducts;

            if (products == null || products.isEmpty) {
              return const SingleChildFullPageScrollView(
                  child: Text("You don't have wishlist"));
            }

            return MasonryGridView.count(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 10),
              crossAxisCount: 2,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final Product product = products[index];
                return SingleProductCard(
                  product: product,
                  isWishlist: true,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
