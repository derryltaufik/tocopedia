import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/helper_variables/constants.dart';

import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
import 'package:tocopedia/presentation/pages/common_widgets/single_child_full_page_scroll_view.dart';
import 'package:tocopedia/presentation/pages/features/review/widgets/product_review_tile.dart';
import 'package:tocopedia/presentation/providers/review_provider.dart';

class ProductReviewsPage extends StatefulWidget {
  static const String routeName = "/reviews/product";

  final Product product;

  const ProductReviewsPage({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductReviewsPage> createState() => _ProductReviewsPageState();
}

class _ProductReviewsPageState extends State<ProductReviewsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _fetchData(context);
    });
  }

  Future<void> _fetchData(BuildContext context) async {
    Provider.of<ReviewProvider>(context, listen: false)
        .getProductReviews(widget.product.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buyer Reviews"),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
          child: AverageRatingSection(
              averageRating: widget.product.averageRating!),
        ),
        const Divider(height: 0),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _fetchData(context),
            child: Consumer<ReviewProvider>(
              builder: (context, reviewProvider, child) {
                if (reviewProvider.getProductReviewsState ==
                    ProviderState.loading) {
                  return const SingleChildFullPageScrollView.loading();
                }
                if (reviewProvider.getProductReviewsState ==
                    ProviderState.error) {
                  return SingleChildFullPageScrollView(
                      child: Text(reviewProvider.message));
                }

                final reviews = reviewProvider.productReviews;

                if (reviews == null || reviews.isEmpty) {
                  return const SingleChildFullPageScrollView(
                      child: Text("Product doesn't have review"));
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: ProductReviewTile(review: review),
                        ),
                        Container(height: 5, color: Colors.black12),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        )
      ]),
    );
  }
}

class AverageRatingSection extends StatelessWidget {
  final double averageRating;

  const AverageRatingSection({
    super.key,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        const Icon(
          Icons.star_rounded,
          color: CustomColors.starColor,
          size: 36,
        ),
        Row(
          textBaseline: TextBaseline.alphabetic,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          children: [
            Text(
              averageRating.toStringAsFixed(1),
              style: theme.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 35),
            ),
            Text(
              "/5.0",
              style: theme.textTheme.bodyMedium!
                  .copyWith(color: Colors.black54, fontSize: 16),
            )
          ],
        ),
      ],
    );
  }
}
