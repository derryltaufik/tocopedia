import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
import 'package:tocopedia/presentation/pages/features/transaction/widgets/single_order_item_card.dart';
import 'package:tocopedia/presentation/providers/order_item_provider.dart';
import 'package:tocopedia/presentation/helper_variables/order_item_status_enum.dart';

class SellerViewOrderPage extends StatefulWidget {
  const SellerViewOrderPage({Key? key}) : super(key: key);

  @override
  State<SellerViewOrderPage> createState() => _SellerViewOrderPageState();
}

class _SellerViewOrderPageState extends State<SellerViewOrderPage>
    with SingleTickerProviderStateMixin {
  static const Map<String, List<Status>> tabStatus = {
    "All Orders": [
      Status.waitingConfirmation,
      Status.processing,
      Status.sent,
      Status.arrivedAtDestination,
      Status.completed,
      Status.refunded,
    ],
    "New Orders": [Status.waitingConfirmation],
    "Ready to Send": [Status.processing],
    "On Shipment": [Status.sent],
    "Completed": [Status.completed],
    "Cancelled": [Status.cancelled, Status.refunded]
  };
  List<String> statusList = tabStatus.keys.map((e) => e).toList();

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    Future.microtask(() {
      Provider.of<OrderItemProvider>(context, listen: false)
          .getSellerOrderItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders  💰"),
        bottom: TabBar(
          onTap: (value) => setState(() {}),
          isScrollable: true,
          controller: _tabController,
          tabs: statusList
              .map(
                (status) => Tab(
                  text: status,
                ),
              )
              .toList(),
        ),
      ),
      body: Consumer<OrderItemProvider>(
        builder: (context, orderItemProvider, child) {
          print("build");
          if (orderItemProvider.getSellerOrderItemsState ==
              ProviderState.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (orderItemProvider.getSellerOrderItemsState ==
              ProviderState.error) {
            return Center(child: Text(orderItemProvider.message));
          }

          final orderItems = orderItemProvider.sellerOrderItemList;

          if (orderItems == null || orderItems.isEmpty) {
            return Center(child: Text("You don't have any order yet."));
          }

          final filteredOrderItems = List.from(orderItems)
            ..removeWhere((orderItem) {
              final List<Status> acceptedStatus =
                  tabStatus[statusList[_tabController.index]]!;
              return !acceptedStatus
                  .any((element) => element.description == orderItem.status);
            });

          if (filteredOrderItems.isEmpty) {
            return Center(
                child: Text(
                    "No order with \"${statusList[_tabController.index]}\" status"));
          }

          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 5),
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            itemCount: filteredOrderItems.length,
            itemBuilder: (context, index) {
              final OrderItem orderItem = filteredOrderItems[index];
              return SingleOrderItemCard(orderItem: orderItem);
            },
          );
        },
      ),
    );
  }
}
