import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:tocopedia/presentation/helper_variables/constants.dart';
import 'package:tocopedia/domains/entities/review.dart';

import 'package:tocopedia/presentation/helper_variables/check_overflow_text.dart';

class ProductReviewTile extends StatefulWidget {
  final Review review;

  const ProductReviewTile({Key? key, required this.review}) : super(key: key);

  @override
  State<ProductReviewTile> createState() => _ProductReviewTileState();
}

class _ProductReviewTileState extends State<ProductReviewTile> {

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Icon(Icons.account_circle),
              ),
            ),
            SizedBox(width: 5),
            Text("${widget.review.buyer?.name}", style: theme.textTheme.titleSmall),
          ],
        ),
        Row(
          children: [
            RatingBar.builder(
              itemSize: 20,
              ignoreGestures: true,
              initialRating: widget.review.rating!.toDouble(),
              itemBuilder: (_, __) =>
                  const Icon(Icons.star_rounded, color: CustomColors.starColor),
              onRatingUpdate: (_) {},
            ),
            const SizedBox(width: 5),
            Text(
              DateFormat("dd MMM yyyy").format(widget.review.updatedAt!),
              style:
                  theme.textTheme.bodyMedium!.copyWith(color: Colors.black54),
            ),
          ],
        ),
        SizedBox(height: 5),
        Builder(
          builder: (_) {
            if (widget.review.review == null || widget.review.review!.isEmpty) {
              return Text(
                "No Review",
                style:
                    theme.textTheme.bodyMedium!.copyWith(color: Colors.black12),
              );
            } else {
              if (isExpanded == false) {
                return Text(
                  widget.review.review!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyLarge,
                );
              } else {
                return Text(
                  widget.review.review!,
                  style: theme.textTheme.bodyLarge,
                );
              }
            }
          },
        ),
        // show "see more" button if text overflow
        LayoutBuilder(builder: (_, BoxConstraints constraints) {
          if (widget.review.review != null && isTextOverflow(widget.review.review!, theme.textTheme.bodyLarge!,
              maxLines: 3, maxWidth: constraints.maxWidth)) {
            return GestureDetector(
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: Text(
                isExpanded ? "See Less" : "See More",
                style: theme.textTheme.bodyLarge!.copyWith(
                    color: theme.primaryColor, fontWeight: FontWeight.bold),
              ),
            );
          }
          return const SizedBox.shrink();
        }),

        if (widget.review.images != null && widget.review.images!.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: widget.review.images!.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return Container(
                  width: 75,
                  height: 75,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.review.images![index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          )
      ],
    );
  }
}
