import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/review.dart';
import 'package:tocopedia/presentation/helper_variables/constants.dart';
import 'package:tocopedia/presentation/helper_variables/future_function_handler.dart';
import 'package:tocopedia/presentation/helper_variables/rating_decoration_enum.dart';
import 'package:tocopedia/presentation/pages/common_widgets/custom_form_field.dart';
import 'package:tocopedia/presentation/pages/common_widgets/images/pick_image_gridview.dart';
import 'package:tocopedia/presentation/pages/common_widgets/images/pick_image_provider.dart';
import 'package:tocopedia/presentation/providers/review_provider.dart';

class AddReviewPageArguments {
  final int initialRating;
  final Review review;

  AddReviewPageArguments({this.initialRating = 0, required this.review});
}

class AddReviewPage extends StatefulWidget {
  static const String routeName = "reviews/add";

  final int initialRating;
  final Review review;

  const AddReviewPage({
    Key? key,
    this.initialRating = 0,
    required this.review,
  }) : super(key: key);

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  late int _rating;
  bool _anonymous = false;
  final _reviewController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final images =
          Provider.of<PickImageProvider>(context, listen: false).newImages;
      final addImageFunction =
          Provider.of<ReviewProvider>(context, listen: false).addReview(
              widget.review.orderItemDetail!.id!,
              rating: _rating,
              anonymous: _anonymous,
              images: images,
              review: _reviewController.text);
      final review = await handleFutureFunction(
        context,
        loadingMessage: "Uploading review...",
        successMessage: "Review added successfully",
        function: addImageFunction,
      );
      if (review != null && context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratingDecoration = RatingDecoration.fromRating(_rating);

    return Scaffold(
      appBar: AppBar(title: const Text("Write A Review")),
      body: ChangeNotifierProvider<PickImageProvider>(
          create: (_) => PickImageProvider(),
          builder: (context, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.review.productImage!,
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                              child: Text(
                            widget.review.productName ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ))
                        ],
                      ),
                      const SizedBox(height: 10),
                      Center(
                          child: Icon(ratingDecoration.icon,
                              size: 60, color: theme.primaryColor)),
                      const SizedBox(height: 5),
                      Center(
                        child: RatingBar.builder(
                          initialRating: widget.initialRating.toDouble(),
                          glow: false,
                          itemSize: 60,
                          itemBuilder: (_, __) => const Icon(Icons.star_rounded,
                              color: CustomColors.starColor),
                          onRatingUpdate: (double value) =>
                              setState(() => _rating = value.toInt()),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: Text(
                          ratingDecoration.description,
                          style: theme.textTheme.titleLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Share the product picture",
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      const PickImageGridView(size: 75, showLabel: false),
                      const SizedBox(height: 20),
                      Text(
                        ratingDecoration.question,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _reviewController,
                        hintText: "Share what you think about this product.",
                        keyboardInputType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      CheckboxFormField(
                        title: Text("Hide your name"),
                        initialValue: _anonymous,
                        onSaved: (newValue) => _anonymous = newValue ?? false,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                              child: FilledButton(
                                  onPressed: () => submit(context),
                                  child: const Text("Submit"))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
