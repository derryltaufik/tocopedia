import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/features/order/view_all_orders_page.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction"),
      ),
      body: Center(
          child: InkWell(
        onTap: () =>
            Navigator.of(context).pushNamed(ViewAllOrdersPage.routeName),
        child: Card(
          child: Text("See Orders"),
        ),
      )),
    );
  }
}
