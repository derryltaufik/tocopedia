import 'package:flutter/material.dart';

class SingleChildFullPageScrollView extends StatelessWidget {
  final Widget? child;

  const SingleChildFullPageScrollView({super.key, this.child});

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
