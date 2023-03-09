import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:tocopedia/presentation/helper_variables/constants.dart';
import 'package:tocopedia/domains/entities/review.dart';
import 'package:tocopedia/presentation/pages/common_widgets/images/photos_horizontal_listview.dart';

import 'package:tocopedia/presentation/pages/features/review/edit_review_page.dart';

class HistoryReviewTile extends StatelessWidget {
  final Review review;

  const HistoryReviewTile({Key? key, required this.review}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.of(context)
          .pushNamed(EditReviewPage.routeName, arguments: review),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${review.productName}",
              style: theme.textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                RatingBar.builder(
                  itemSize: 20,
                  ignoreGestures: true,
                  initialRating: review.rating?.toDouble() ?? 0,
                  itemBuilder: (_, __) => const Icon(Icons.star_rounded,
                      color: CustomColors.starColor),
                  onRatingUpdate: (_) {},
                ),
                const SizedBox(width: 10),
                Text(
                  DateFormat("dd MMM yyyy").format(review.updatedAt!),
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 4),
            (review.review == null || review.review!.isEmpty)
                ? Text(
                    "No Review",
                    style: theme.textTheme.bodyMedium!
                        .copyWith(color: Colors.black12),
                  )
                : Text(
                    "${review.review}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
            if (review.images != null && review.images!.isNotEmpty)
              PhotosHorizontalListView(images: review.images!)
          ],
        ),
      ),
    );
  }
}
