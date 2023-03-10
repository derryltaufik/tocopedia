import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/helper_variables/format_rupiah.dart';
import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/domains/entities/order_item_detail.dart';
import 'package:tocopedia/presentation/helper_variables/future_function_handler.dart';
import 'package:tocopedia/presentation/pages/features/home/home_page.dart';
import 'package:tocopedia/presentation/providers/order_provider.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';

import 'package:tocopedia/presentation/pages/common_widgets/single_child_full_page_scroll_view.dart';

class ViewOrderPage extends StatefulWidget {
  static const String routeName = "orders/view";

  final String orderId;

  const ViewOrderPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<ViewOrderPage> createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _fetchData(context);
    });
  }

  Future<void> _fetchData(BuildContext context) async {
    Provider.of<OrderProvider>(context, listen: false).getOrder(widget.orderId);
  }

  Future<void> payOrder(BuildContext context) async {
    await handleFutureFunction(context,
        loadingMessage: "Processing payment...",
        successMessage: "Payment Successful!",
        function: Provider.of<OrderProvider>(context, listen: false)
            .payOrder(widget.orderId),
        onSuccess: () => Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false));
  }

  Future<void> cancelOrder(BuildContext context) async {
    await handleFutureFunction(
      context,
      loadingMessage: "Cancelling order...",
      successMessage: "Order Cancelled",
      function: Provider.of<OrderProvider>(context, listen: false)
          .cancelOrder(widget.orderId),
      onSuccess: () => Navigator.of(context)
          .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false),
    );
  }

  Widget _buildProductTile(OrderItemDetail product, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.productName!,
                style: theme.textTheme.titleSmall,
                softWrap: true,
              ),
              Text(
                "${product.quantity} X ${rupiahFormatter.format(product.productPrice)}",
                style:
                    theme.textTheme.bodyMedium!.copyWith(color: Colors.black54),
              ),
            ],
          ),
        ),
        Text(rupiahFormatter.format(product.quantity! * product.productPrice!)),
      ],
    );
  }

  Widget _buildOrderItemTile(
      Address address, OrderItem orderItem, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(orderItem.seller!.name!, style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        ...orderItem.orderItemDetails!
            .map((product) => _buildProductTile(product, theme))
            .toList(),
        const SizedBox(height: 15),
        Text("Shipment Address", style: theme.textTheme.titleSmall),
        Text(
          "${address.receiverName!}\n${address.receiverPhone!}\n${address.completeAddress!}",
          style: theme.textTheme.bodyMedium!.copyWith(color: Colors.black54),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order"),
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchData(context),
        child:
            Consumer<OrderProvider>(builder: (context, orderProvider, child) {
          if (orderProvider.getOrderState == ProviderState.loading) {
            return const SingleChildFullPageScrollView.loading();
          }
          if (orderProvider.getOrderState == ProviderState.error) {
            return SingleChildFullPageScrollView(
                child: Text(orderProvider.message));
          }
          final order = orderProvider.order;

          if (order == null) {
            return const SingleChildFullPageScrollView(
                child: Text("Order not found"));
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Payment Detail", style: theme.textTheme.titleLarge),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total Price",
                              style: theme.textTheme.titleMedium),
                          Text(rupiahFormatter.format(order.totalPrice),
                              style: theme.textTheme.titleMedium),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Product Bought", style: theme.textTheme.titleLarge),
                      const SizedBox(height: 20),
                      ...order.orderItems!.map(
                        (orderItem) {
                          return _buildOrderItemTile(
                              order.address!, orderItem, theme);
                        },
                      ).toList(),
                      if (order.status! == "unpaid")
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            OutlinedButton(
                                onPressed: () => cancelOrder(context),
                                child: const Text("Cancel Order")),
                            const SizedBox(width: 20),
                            Expanded(
                                child: FilledButton(
                                    onPressed: () => payOrder(context),
                                    child: const Text("Pay Now")))
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
