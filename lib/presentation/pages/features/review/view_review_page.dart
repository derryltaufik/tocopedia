import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/helper_variables/constants.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
import 'package:tocopedia/presentation/pages/common_widgets/images/photos_horizontal_listview.dart';
import 'package:tocopedia/presentation/pages/common_widgets/single_child_full_page_scroll_view.dart';
import 'package:tocopedia/presentation/providers/review_provider.dart';
import 'package:tocopedia/presentation/pages/features/review/edit_review_page.dart';

import 'package:tocopedia/presentation/pages/features/product/view_product_page.dart';

class ViewReviewPage extends StatefulWidget {
  static const String routeName = "reviews/view";

  final String reviewId;

  const ViewReviewPage({Key? key, required this.reviewId}) : super(key: key);

  @override
  State<ViewReviewPage> createState() => _ViewReviewPageState();
}

class _ViewReviewPageState extends State<ViewReviewPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _fetchData(context);
    });
  }

  Future<void> _fetchData(BuildContext context) async {
    Provider.of<ReviewProvider>(context, listen: false)
        .getReview(widget.reviewId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        final review = reviewProvider.review;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Review Detail"),
            actions: [
              IconButton(
                  onPressed: review == null
                      ? null
                      : () => Navigator.of(context).pushNamed(
                          EditReviewPage.routeName,
                          arguments: review),
                  icon: const Icon(Icons.edit_rounded))
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => _fetchData(context),
            child: Builder(
              builder: (context) {
                if (reviewProvider.getReviewState == ProviderState.loading) {
                  return const SingleChildFullPageScrollView.loading();
                }
                if (reviewProvider.getReviewState == ProviderState.error) {
                  return SingleChildFullPageScrollView(
                      child: Text(reviewProvider.message));
                }

                final review = reviewProvider.review;

                if (review == null) {
                  return const SingleChildFullPageScrollView(
                      child: Text("Review not found"));
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        ViewProductCard(
                            productId: review.product!.id!,
                            name: review.productName!,
                            image: review.productImage!),
                        const SizedBox(height: 5),
                        RatingBar.builder(
                          itemSize: 16,
                          initialRating: review.rating!.toDouble(),
                          ignoreGestures: true,
                          itemBuilder: (context, index) => const Icon(
                              Icons.star_rounded,
                              color: CustomColors.starColor),
                          onRatingUpdate: (value) {},
                        ),
                        Text.rich(
                          TextSpan(
                            text: "As ",
                            children: [
                              TextSpan(
                                  text: "${review.buyer?.name}",
                                  style:
                                      const TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text:
                                      " - ${DateFormat("dd MMM yyyy").format(review.updatedAt!)}"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                            review.review == null
                                ? "No review"
                                : "${review.review}",
                            style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 5),
                        if (review.images != null && review.images!.isNotEmpty)
                          PhotosHorizontalListView(images: review.images!),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class ViewProductCard extends StatelessWidget {
  final String productId;
  final String name;
  final String image;

  const ViewProductCard(
      {Key? key,
      required this.productId,
      required this.name,
      required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(ViewProductPage.routeName, arguments: productId),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(children: [
            CachedNetworkImage(
              imageUrl: image,
              width: 50,
              height: 50,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
