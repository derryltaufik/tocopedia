import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/presentation/pages/common_widgets/cart_button_appbar.dart';
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
      Provider.of<OrderItemProvider>(context, listen: false)
          .getBuyerOrderItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CartButtonAppBar(title: "Transactions 🧾"),
      body: Column(
        children: [
          Expanded(
            child: Consumer<OrderItemProvider>(
              builder: (context, orderItemProvider, child) {
                if (orderItemProvider.getBuyerOrderItemsState ==
                    ProviderState.loading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (orderItemProvider.getBuyerOrderItemsState ==
                    ProviderState.error) {
                  return Center(child: Text(orderItemProvider.message));
                }

                final orderItems = orderItemProvider.buyerOrderItemList;

                if (orderItems?.isEmpty ?? true) {
                  return Center(child: Text("You don't have any order yet."));
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => SizedBox(height: 5),
                    itemCount: orderItems!.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) return WaitingPaymentCard();
                      index--;
                      final OrderItem orderItem = orderItems[index];
                      return SingleOrderItemCard(orderItem: orderItem);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
