import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
import 'package:tocopedia/presentation/pages/common_widgets/single_child_full_page_scroll_view.dart';
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
      if (Provider.of<OrderItemProvider>(context, listen: false)
              .getSellerOrderItemsState !=
          ProviderState.loaded) {
        _fetchData(context);
      }
    });
  }

  Future<void> _fetchData(BuildContext context) async {
    Provider.of<OrderItemProvider>(context, listen: false)
        .getSellerOrderItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders  💰"),
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
      body: RefreshIndicator(
        onRefresh: () => _fetchData(context),
        child: Consumer<OrderItemProvider>(
          builder: (context, orderItemProvider, child) {
            if (orderItemProvider.getSellerOrderItemsState ==
                ProviderState.loading) {
              return const SingleChildFullPageScrollView.loading();
            }
            if (orderItemProvider.getSellerOrderItemsState ==
                ProviderState.error) {
              return SingleChildFullPageScrollView(
                  child: Text(orderItemProvider.message));
            }

            final orderItems = orderItemProvider.sellerOrderItemList;

            if (orderItems == null || orderItems.isEmpty) {
              return const SingleChildFullPageScrollView(
                  child: Text("You don't have any order yet."));
            }

            final filteredOrderItems = List.from(orderItems)
              ..removeWhere((orderItem) {
                final List<Status> acceptedStatus =
                    tabStatus[statusList[_tabController.index]]!;
                return !acceptedStatus
                    .any((element) => element.description == orderItem.status);
              });

            if (filteredOrderItems.isEmpty) {
              return SingleChildFullPageScrollView(
                  child: Text(
                      "No order with \"${statusList[_tabController.index]}\" status"));
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const SizedBox(height: 5),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
              itemCount: filteredOrderItems.length,
              itemBuilder: (context, index) {
                final OrderItem orderItem = filteredOrderItems[index];
                return SingleOrderItemCard(orderItem: orderItem);
              },
            );
          },
        ),
      ),
    );
  }
}
