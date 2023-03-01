import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/order_item.dart';
import 'package:tocopedia/presentation/helper_variables/future_function_handler.dart';
import 'package:tocopedia/presentation/helper_variables/order_item_status_enum.dart';
import 'package:tocopedia/presentation/providers/local_settings_provider.dart';
import 'package:tocopedia/presentation/providers/order_item_provider.dart';

class OrderItemActionButton extends StatelessWidget {
  final OrderItem orderItem;

  const OrderItemActionButton({
    super.key,
    required this.orderItem,
  });

  Future<void> cancelOrderItem(BuildContext context) async {
    await handleFutureFunction(
      context,
      loadingMessage: "Cancelling Order...",
      successMessage: "Order Cancelled",
      function: Provider.of<OrderItemProvider>(context, listen: false)
          .cancelOrderItem(orderItem.id!),
    );
  }

  Future<void> processOrderItem(BuildContext context) async {
    await handleFutureFunction(
      context,
      successMessage: "Order Processed",
      function: Provider.of<OrderItemProvider>(context, listen: false)
          .processOrderItem(orderItem.id!),
    );
  }

  Future<void> sendOrderItem(BuildContext context) async {
    final airwaybill = await showDialog<String>(
      context: context,
      builder: (context) => InputAirwayBillDialog(),
    );
    if (airwaybill != null && airwaybill.isNotEmpty && context.mounted) {
      await handleFutureFunction(
        context,
        successMessage: "Shipment info updated",
        function: Provider.of<OrderItemProvider>(context, listen: false)
            .sendOrderItem(orderItem.id!, airwaybill),
      );
    }
  }

  Future<void> completeOrderItem(BuildContext context) async {
    await handleFutureFunction(
      context,
      successMessage: "Order Completed!",
      function: Provider.of<OrderItemProvider>(context, listen: false)
          .completeOrderItem(orderItem.id!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusEnum = Status.fromString(orderItem.status!);
    final appMode =
        Provider.of<LocalSettingsProvider>(context, listen: false).appMode;

    if (appMode == AppMode.buyer) {
      if (!(statusEnum == Status.waitingConfirmation ||
          statusEnum == Status.completed ||
          statusEnum == Status.sent ||
          statusEnum == Status.arrivedAtDestination)) {
        return const SizedBox.shrink();
      }
    } else if (appMode == AppMode.seller) {
      if (!(statusEnum == Status.waitingConfirmation ||
          statusEnum == Status.processing)) {
        return const SizedBox.shrink();
      }
    }

    return Container(
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
      child: Row(children: [
        Expanded(
          child: Builder(
            builder: (context) {
              final buttonStyle = FilledButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.titleMedium);
              if (statusEnum == Status.waitingConfirmation &&
                  appMode == AppMode.buyer) {
                return OutlinedButton(
                  style: buttonStyle,
                  child: Text("Cancel Order"),
                  onPressed: () => cancelOrderItem(context),
                );
              } else if (statusEnum == Status.waitingConfirmation &&
                  appMode == AppMode.seller) {
                return Row(
                  children: [
                    OutlinedButton(
                      style: buttonStyle,
                      child: Text("Cancel Order"),
                      onPressed: () => cancelOrderItem(context),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: FilledButton(
                        style: buttonStyle,
                        child: Text("Process Order"),
                        onPressed: () => processOrderItem(context),
                      ),
                    ),
                  ],
                );
              } else if (statusEnum == Status.processing) {
                return FilledButton(
                  style: buttonStyle,
                  child: Text("Send Order"),
                  onPressed: () => sendOrderItem(context),
                );
              } else if (statusEnum == Status.sent ||
                  statusEnum == Status.arrivedAtDestination) {
                return FilledButton(
                  style: buttonStyle,
                  child: Text("Finish Order"),
                  onPressed: () => completeOrderItem(context),
                );
              } else if (statusEnum == Status.completed) {
                return FilledButton(
                  style: buttonStyle,
                  child: Text("Review Product"),
                  onPressed: () {},
                );
              }
              return SizedBox.shrink();
            },
          ),
        ),
      ]),
    );
  }
}

class InputAirwayBillDialog extends StatefulWidget {
  const InputAirwayBillDialog({Key? key}) : super(key: key);

  @override
  State<InputAirwayBillDialog> createState() => _InputAirwayBillDialogState();
}

class _InputAirwayBillDialogState extends State<InputAirwayBillDialog> {
  final _airwaybillController = TextEditingController();

  @override
  void dispose() {
    _airwaybillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Input Airwaybill"),
      content: TextField(
        decoration: InputDecoration(counterText: "", labelText: "Airwaybill"),
        controller: _airwaybillController,
        maxLength: 30,
      ),
      actions: [
        FilledButton(
          child: Text("OK"),
          onPressed: () =>
              Navigator.of(context).pop(_airwaybillController.text),
        ),
      ],
    );
  }
}
