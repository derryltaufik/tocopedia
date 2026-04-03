import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/review.dart';
import 'package:tocopedia/presentation/pages/common_widgets/cart_button_appbar.dart';
import 'package:tocopedia/presentation/pages/common_widgets/single_child_full_page_scroll_view.dart';
import 'package:tocopedia/presentation/pages/features/review/widgets/history_review_tile.dart';
import 'package:tocopedia/presentation/pages/features/review/widgets/pending_review_tile.dart';

import 'package:tocopedia/presentation/providers/review_provider.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';

class BuyerReviewsPage extends StatefulWidget {
  static const String routeName = "/reviews/buyer";

  const BuyerReviewsPage({Key? key}) : super(key: key);

  @override
  State<BuyerReviewsPage> createState() => _BuyerReviewsPageState();
}

class _BuyerReviewsPageState extends State<BuyerReviewsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    Future.microtask(() {
      if (Provider.of<ReviewProvider>(context, listen: false)
              .getBuyerReviewsState !=
          ProviderState.loaded) {
        _fetchData(context);
      }
    });
  }

  Future<void> _fetchData(BuildContext context) async {
    Provider.of<ReviewProvider>(context, listen: false).getBuyerReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CartButtonAppBar(
        title: "Reviews ⭐",
        bottom: TabBar(
          onTap: (value) => setState(() {}),
          controller: _tabController,
          tabs: const [Tab(text: "Waiting For Review"), Tab(text: "History")],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchData(context),
        child: Consumer<ReviewProvider>(
          builder: (context, reviewProvider, child) {
            if (reviewProvider.getBuyerReviewsState == ProviderState.loading) {
              return const SingleChildFullPageScrollView.loading();
            }
            if (reviewProvider.getBuyerReviewsState == ProviderState.error) {
              return SingleChildFullPageScrollView(
                  child: Text(reviewProvider.message));
            }

            final reviews = reviewProvider.buyerReviews;

            if (reviews == null || reviews.isEmpty) {
              return const SingleChildFullPageScrollView(
                  child: Text("You don't have any reviews yet."));
            }

            final filteredReviews = List<Review>.from(reviews);

            if (_tabController.index == 0) {
              filteredReviews
                  .removeWhere((element) => element.completed! == true);
              if (filteredReviews.isEmpty) {
                return const SingleChildFullPageScrollView(
                    child: Text("You don't have pending review"));
              }
            } else {
              filteredReviews
                  .removeWhere((element) => element.completed! == false);
              if (filteredReviews.isEmpty) {
                return const SingleChildFullPageScrollView(
                    child: Text("You haven't reviewed any product"));
              }
            }

            return _tabController.index == 0
                ? ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(8),
                    separatorBuilder: (context, index) => const SizedBox(height: 5),
                    itemCount: filteredReviews.length,
                    itemBuilder: (context, index) {
                      final review = filteredReviews[index];
                      return PendingReviewTile(review: review);
                    },
                  )
                : ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filteredReviews.length,
                    itemBuilder: (context, index) {
                      final review = filteredReviews[index];
                      return Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: HistoryReviewTile(review: review),
                          ),
                          Container(height: 5, color: Colors.black12),
                        ],
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
