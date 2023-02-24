import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/order.dart';
import 'package:tocopedia/presentation/pages/features/order/widgets/single_order_card.dart';
import 'package:tocopedia/presentation/providers/order_provider.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';

class ViewAllOrdersPage extends StatefulWidget {
  static const String routeName = "/orders/view-all";

  const ViewAllOrdersPage({Key? key}) : super(key: key);

  @override
  State<ViewAllOrdersPage> createState() => _ViewAllOrdersPageState();
}

class _ViewAllOrdersPageState extends State<ViewAllOrdersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OrderProvider>(context, listen: false).getUserOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Your Orders")),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.getUserOrdersState == ProviderState.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (orderProvider.getUserOrdersState == ProviderState.error) {
            return Center(child: Text(orderProvider.message));
          }

          final orders = orderProvider.orderList;

          if (orders == null || orders.isEmpty) {
            return Center(child: Text("You don't have any order."));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 15),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final Order order = orders[index];
                return SingleOrderCard(order: order);
              },
            ),
          );
        },
      ),
    );
  }
}
