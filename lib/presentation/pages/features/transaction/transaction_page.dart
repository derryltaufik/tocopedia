import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/presentation/pages/common_widgets/cart_button_appbar.dart';
import 'package:tocopedia/presentation/pages/common_widgets/single_child_full_page_scroll_view.dart';
import 'package:tocopedia/presentation/pages/features/transaction/widgets/single_order_item_card.dart';
import 'package:tocopedia/presentation/pages/features/transaction/widgets/waiting_payment_card.dart';
import 'package:tocopedia/presentation/providers/order_item_provider.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';

class TransactionPage extends StatefulWidget {
  static const String routeName = "/transactions";

  const TransactionPage({Key? key}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _fetchData(context);
    });
  }

  Future<void> _fetchData(BuildContext context) async {
    Provider.of<OrderItemProvider>(context, listen: false).getBuyerOrderItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CartButtonAppBar(title: "Transactions 🧾"),
      body: RefreshIndicator(
        onRefresh: () => _fetchData(context),
        child: Consumer<OrderItemProvider>(
          builder: (context, orderItemProvider, child) {
            if (orderItemProvider.getBuyerOrderItemsState ==
                ProviderState.loading) {
              return const SingleChildFullPageScrollView.loading();
            }
            if (orderItemProvider.getBuyerOrderItemsState ==
                ProviderState.error) {
              return SingleChildFullPageScrollView(
                  child: Text(orderItemProvider.message));
            }

            final orderItems = orderItemProvider.buyerOrderItemList;

            if (orderItems == null || orderItems.isEmpty) {
              return const SingleChildFullPageScrollView(
                  child: Text("You don't have any order yet."));
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              itemCount: orderItems.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) return const WaitingPaymentCard();
                index--;
                final OrderItem orderItem = orderItems[index];
                return SingleOrderItemCard(orderItem: orderItem);
              },
            );
          },
        ),
      ),
    );
  }
}
