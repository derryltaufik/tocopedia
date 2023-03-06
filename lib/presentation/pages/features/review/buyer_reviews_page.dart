import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/pages/common_widgets/cart_button_appbar.dart';
import 'package:tocopedia/presentation/providers/review_provider.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';

class BuyerReviewsPage extends StatefulWidget {
  static const String routeName = "/reviews";

  const BuyerReviewsPage({Key? key}) : super(key: key);

  @override
  State<BuyerReviewsPage> createState() => _BuyerReviewsPageState();
}

class _BuyerReviewsPageState extends State<BuyerReviewsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ReviewProvider>(context, listen: false).getBuyerReviews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CartButtonAppBar(title: "Reviews ⭐"),
      body: Consumer<ReviewProvider>(
        builder: (context, reviewProvider, child) {
          if (reviewProvider.getBuyerReviewsState == ProviderState.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (reviewProvider.getBuyerReviewsState == ProviderState.error) {
            return Center(child: Text(reviewProvider.message));
          }

          final reviews = reviewProvider.buyerReviews;
          print(reviews);

          if (reviews == null || reviews.isEmpty) {
            return Center(child: Text("You don't have any reviews yet."));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 5),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ListTile(title: Text("${review.rating}"));
              },
            ),
          );
        },
      ),
    );
  }
}
