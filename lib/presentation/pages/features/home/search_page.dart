import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/common_widgets/home_appbar.dart';

class SearchPage extends StatelessWidget {
  static const routeName = "/products/search";

  final String searchQuery;

  const SearchPage({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: Text("Seach Page"),
    );
  }
}
