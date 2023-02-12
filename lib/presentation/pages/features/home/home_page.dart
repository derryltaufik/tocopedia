import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/common_widgets/home_appbar.dart';

class HomePage extends StatelessWidget {
  static const String routeName = "/";

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: HomeAppBar());
  }
}
