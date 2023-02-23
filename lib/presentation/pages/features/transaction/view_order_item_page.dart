import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';
import 'package:tocopedia/presentation/helper_variables/string_extension.dart';
import 'package:tocopedia/presentation/pages/features/order/view_order_page.dart';
import 'package:tocopedia/presentation/providers/order_item_provider.dart';
import 'package:tocopedia/presentation/pages/features/transaction/widgets/single_order_item_detail_card.dart';

class ViewOrderItemPage extends StatefulWidget {
  static const String routeName = "order-items/view";

  final String orderItemId;

  const ViewOrderItemPage({Key? key, required this.orderItemId})
      : super(key: key);

  @override
  State<ViewOrderItemPage> createState() => _ViewOrderItemPageState();
}

class _ViewOrderItemPageState extends State<ViewOrderItemPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OrderItemProvider>(context, listen: false)
          .getOrderItem(widget.orderItemId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Detail"),
      ),
      body: Column(
        children: [
          Consumer<OrderItemProvider>(
              builder: (context, orderItemProvider, child) {
            if (orderItemProvider.getOrderItemState == ProviderState.loading) {
              return Expanded(
                  child: Center(child: CircularProgressIndicator()));
            }
            if (orderItemProvider.getOrderItemState == ProviderState.error) {
              return Expanded(
                  child: Center(child: Text(orderItemProvider.message)));
            }

            final orderItem = orderItemProvider.orderItem;

            if (orderItem == null) {
              return Expanded(
                  child: Center(child: Text("You don't have any order yet.")));
            }

            return Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: OrderItemInfoSection(orderItem: orderItem),
                    ),
                    Container(height: 10, color: Colors.black12),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ProductDetailsSection(orderItem: orderItem),
                    ),
                    Container(height: 10, color: Colors.black12),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ShippingInfoSection(orderItem: orderItem),
                    ),
                    Container(height: 10, color: Colors.black12),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: PaymentDetailsSection(orderItem: orderItem),
                    ),
                    Container(height: 0, color: Colors.black12),
                  ],
                ),
              ),
            );
          }),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(1),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.titleMedium),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Text("Review Product"),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PaymentDetailsSection extends StatelessWidget {
  const PaymentDetailsSection({
    super.key,
    required this.orderItem,
  });

  final OrderItem orderItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Payment Details",
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Payment Method",
              style:
                  theme.textTheme.bodyMedium!.copyWith(color: Colors.black54),
            ),
            Text("Tocopedia Pay")
          ],
        ),
        Divider(thickness: 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total Expense",
              style: theme.textTheme.titleMedium,
            ),
            Text(
              rupiahFormatter.format(orderItem.subtotal!),
              style: theme.textTheme.titleMedium,
            )
          ],
        ),
      ],
    );
  }
}

class ShippingInfoSection extends StatelessWidget {
  const ShippingInfoSection({
    super.key,
    required this.orderItem,
  });

  final OrderItem orderItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Shipping Info",
          style: theme.textTheme.titleMedium,
        ),
        SizedBox(height: 10),
        Table(
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          children: <TableRow>[
            TableRow(
              children: <Widget>[
                Text(
                  "Courier",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: Colors.black54),
                ),
                Text("Tocopedia Express"),
              ],
            ),
            const TableRow(
                children: [SizedBox(height: 10), SizedBox(height: 10)]),
            // add spacing
            TableRow(
              children: <Widget>[
                Text(
                  "Airwaybill",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: Colors.black54),
                ),
                Text(orderItem.airwaybill ?? "-"),
              ],
            ),
            const TableRow(
                children: [SizedBox(height: 10), SizedBox(height: 10)]),
            // add spacing
            TableRow(
              children: <Widget>[
                Text(
                  "Address",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: Colors.black54),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${orderItem.order!.address!.receiverName!}",
                      style: theme.textTheme.bodyMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                        "${orderItem.order!.address!.receiverPhone!}\n${orderItem.order!.address!.completeAddress!}"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class ProductDetailsSection extends StatelessWidget {
  const ProductDetailsSection({
    super.key,
    required this.orderItem,
  });

  final OrderItem orderItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Product Details",
              style: theme.textTheme.titleMedium,
            ),
            Text(
              "${orderItem.seller!.name!} Store",
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
        SizedBox(height: 10),
        ListView.separated(
          separatorBuilder: (context, index) => SizedBox(height: 5),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: orderItem.products!.length,
          itemBuilder: (context, index) {
            final orderItemDetail = orderItem.products![index];
            return SingleOrderItemDetailCard(orderItemDetail: orderItemDetail);
          },
        )
      ],
    );
  }
}

class OrderItemInfoSection extends StatelessWidget {
  const OrderItemInfoSection({
    super.key,
    required this.orderItem,
  });

  final OrderItem orderItem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(orderItem.status!.toTitleCase(),
            style: theme.textTheme.titleMedium),
        Divider(thickness: 0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "ORDER/${DateFormat("yyyyMMd").format(orderItem.order!.createdAt!)}/${orderItem.order!.id!.substring(orderItem.order!.id!.length - 10).toUpperCase()}",
              style:
                  theme.textTheme.bodyMedium!.copyWith(color: Colors.black54),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                  ViewOrderPage.routeName,
                  arguments: orderItem.order!.id!),
              child: Text(
                "View Order",
                style: theme.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold, color: theme.primaryColor),
              ),
            )
          ],
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Date Bought",
              style:
                  theme.textTheme.bodyMedium!.copyWith(color: Colors.black54),
            ),
            Text(DateFormat("d MMMM yyyy, HH:mm")
                .format(orderItem.order!.createdAt!.toLocal()))
          ],
        ),
      ],
    );
  }
}
