import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/helper_variables/search_arguments.dart';
import 'package:tocopedia/presentation/pages/common_widgets/home_appbar.dart';

class ViewSellerHomePage extends StatefulWidget {
  static const routeName = "/seller/home";

  final SearchArguments searchArguments;

  const ViewSellerHomePage({super.key, required this.searchArguments});

  @override
  State<ViewSellerHomePage> createState() => _ViewSellerHomePageState();
}

class _ViewSellerHomePageState extends State<ViewSellerHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(query: widget.searchArguments.searchQuery ?? ""),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Seller Page under construction"),
            FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Go Back"))
          ],
        ),
      ),
    );
  }
}
