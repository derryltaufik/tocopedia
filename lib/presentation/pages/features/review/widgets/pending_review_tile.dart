import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:tocopedia/presentation/helper_variables/constants.dart';
import 'package:tocopedia/domains/entities/review.dart';
import 'package:tocopedia/presentation/pages/features/review/add_review_page.dart';

class PendingReviewTile extends StatelessWidget {
  final Review review;

  const PendingReviewTile({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        AddReviewPage.routeName,
        arguments: AddReviewPageArguments(
          review: review,
          initialRating: 5,
        ),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 75,
                height: 75,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                child: CachedNetworkImage(
                  imageUrl: review.productImage!,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat("dd MMM yyyy").format(review.createdAt!),
                      style: theme.textTheme.bodyMedium!
                          .copyWith(color: Colors.black54),
                    ),
                    Text(
                      "${review.productName}",
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    RatingBar.builder(
                      onRatingUpdate: (double value) =>
                          Navigator.of(context).pushNamed(
                        AddReviewPage.routeName,
                        arguments: AddReviewPageArguments(
                          review: review,
                          initialRating: value.toInt(),
                        ),
                      ),
                      glow: false,
                      itemBuilder: (_, __) => const Icon(Icons.star_rounded,
                          color: CustomColors.starColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
