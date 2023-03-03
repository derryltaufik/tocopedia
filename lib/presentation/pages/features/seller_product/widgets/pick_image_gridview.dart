import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/features/seller_product/providers/pick_image_provider.dart';
import 'package:tocopedia/presentation/pages/features/seller_product/widgets/pick_image_tile.dart';

class PickImageGridView extends StatelessWidget {
  const PickImageGridView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, mainAxisSpacing: 10),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: PickImageProvider.size,
      itemBuilder: (context, index) => PickImageTile(
        label: index == 0 ? "Main" : "${index + 1}",
        index: index,
      ),
    );
  }
}
