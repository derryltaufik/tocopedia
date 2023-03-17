import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/helper_variables/format_rupiah.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/presentation/helper_variables/search_arguments.dart';
import 'package:tocopedia/presentation/pages/common_widgets/home_appbar.dart';
import 'package:tocopedia/presentation/pages/common_widgets/single_child_full_page_scroll_view.dart';
import 'package:tocopedia/presentation/pages/features/product/view_seller_home_page.dart';
import 'package:tocopedia/presentation/pages/features/product/widgets/add_to_cart_button.dart';
import 'package:tocopedia/presentation/pages/features/product/widgets/product_image_carousel.dart';
import 'package:tocopedia/presentation/pages/features/product/widgets/wishlist_button.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
import 'package:tocopedia/presentation/pages/features/review/product_reviews_page.dart';
import 'package:tocopedia/presentation/helper_variables/constants.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = "products/view";

  final String productId;

  const ViewProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _fetchData(context);
    });
  }

  Future<void> _fetchData(BuildContext context) async {
    Provider.of<ProductProvider>(context, listen: false)
        .getProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final priceStyle = theme.textTheme.titleMedium!
        .copyWith(fontWeight: FontWeight.bold, fontSize: 24);
    final subHeadingStyle = theme.textTheme.titleMedium!
        .copyWith(fontWeight: FontWeight.bold, fontSize: 20);
    return Scaffold(
      appBar: const HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: () => _fetchData(context),
        child: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            if (productProvider.getProductState == ProviderState.loading) {
              return const SingleChildFullPageScrollView.loading();
            }
            if (productProvider.getProductState == ProviderState.error) {
              return SingleChildFullPageScrollView(
                  child: Text(productProvider.message));
            }
            final product = productProvider.product;

            if (product == null) {
              return const SingleChildFullPageScrollView(
                  child: Text("Product not found"));
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImageCarousel(images: product.images!),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              rupiahFormatter.format(product.price),
                              style: priceStyle,
                            ),
                            WishlistButton(productId: product.id!),
                          ],
                        ),
                        Text(
                          product.name!,
                          style: theme.textTheme.bodyLarge,
                        ),
                        if (product.totalSold != null &&
                            product.totalSold! > 0) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                "Sold ${NumberFormat.decimalPattern("id_ID").format(product.totalSold)}",
                              ),
                              const SizedBox(width: 8),
                              if (product.totalRating != null &&
                                  product.totalRating! > 0)
                                RatingButton(product: product),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Product Description", style: subHeadingStyle),
                        const SizedBox(height: 5),
                        Text(product.description!,
                            style: theme.textTheme.bodyLarge),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pushNamed(
                        ViewSellerHomePage.routeName,
                        arguments: SearchArguments(sellerId: product.owner?.id),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.storefront_outlined, size: 40),
                          SizedBox(width: 10),
                          Text("${product.owner?.name}",
                              style: subHeadingStyle),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: AddToCartButton(productId: widget.productId),
    );
  }
}

class RatingButton extends StatelessWidget {
  final Product product;

  const RatingButton({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(ProductReviewsPage.routeName, arguments: product),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Colors.black12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4),
          child: Row(
            children: [
              const Icon(
                Icons.star_rounded,
                color: CustomColors.starColor,
                size: 20,
              ),
              Text("${product.averageRating?.toStringAsFixed(1)} "),
              Text(
                "(${product.totalRating})",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
