import 'package:flutter/material.dart';

class SingleChildFullPageScrollView extends StatelessWidget {
  final Widget? child;

  const SingleChildFullPageScrollView({Key? key, this.child}) : super(key: key);

  const SingleChildFullPageScrollView.loading({super.key})
      : child = const CircularProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          child: Center(child: child),
        )
      ],
    );
  }
}
