import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/domains/entities/address.dart';
import 'package:tocopedia/domains/entities/order.dart';
import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/domains/entities/order_item_detail.dart';
import 'package:tocopedia/presentation/pages/common_widgets/loading_dialog.dart';
import 'package:tocopedia/presentation/pages/features/home/home_page.dart';
import 'package:tocopedia/presentation/providers/order_provider.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';

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
      Provider.of<OrderProvider>(context, listen: false)
          .getOrder(widget.orderId);
    });
  }

  Future<void> payOrder(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return LoadingDialog(
          message: "Processing payment...",
        );
      },
    );
    try {
      await Provider.of<OrderProvider>(context, listen: false)
          .payOrder(widget.orderId);

      if (context.mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Payment Successfull!"),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } on Exception catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
        ),
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Future<void> cancelOrder(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return LoadingDialog(
          message: "Cancelling order...",
        );
      },
    );
    try {
      await Provider.of<OrderProvider>(context, listen: false)
          .cancelOrder(widget.orderId);

      if (context.mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(HomePage.routeName, (route) => false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Order Cancelled"),
          behavior: SnackBarBehavior.floating,
        ));
      }
    } on Exception catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          e.toString(),
        ),
        behavior: SnackBarBehavior.floating,
      ));
    }
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
        SizedBox(height: 10),
        ...orderItem.products!
            .map((product) => _buildProductTile(product, theme))
            .toList(),
        SizedBox(height: 15),
        Text("Shipment Address", style: theme.textTheme.titleSmall),
        Text(
          "${address.receiverName!}\n${address.receiverPhone!}\n${address.completeAddress!}",
          style: theme.textTheme.bodyMedium!.copyWith(color: Colors.black54),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order"),
      ),
      body: Consumer<OrderProvider>(builder: (context, orderProvider, child) {
        if (orderProvider.getOrderState == ProviderState.loading ||
            orderProvider.getOrderState == ProviderState.empty) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (orderProvider.getOrderState == ProviderState.error) {
          return Center(child: Text(orderProvider.message));
        }
        final Order order = orderProvider.order!;
        final theme = Theme.of(context);
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Payment Detail", style: theme.textTheme.titleLarge),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Price", style: theme.textTheme.titleMedium),
                        Text(rupiahFormatter.format(order.totalPrice),
                            style: theme.textTheme.titleMedium),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Product Bought", style: theme.textTheme.titleLarge),
                    SizedBox(height: 20),
                    ...order.orderItems!.map(
                      (orderItem) {
                        return _buildOrderItemTile(
                            order.address!, orderItem, theme);
                      },
                    ).toList(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        OutlinedButton(
                            onPressed: () => cancelOrder(context),
                            child: Text("Cancel Order")),
                        SizedBox(width: 20),
                        Expanded(
                            child: FilledButton(
                                onPressed: () => payOrder(context),
                                child: Text("Pay Now")))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
