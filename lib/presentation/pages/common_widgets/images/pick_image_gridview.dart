import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/common_widgets/images/pick_image_tile.dart';

class PickImageGridView extends StatelessWidget {
  final double size;
  final int itemCount;
  final bool showLabel;

  const PickImageGridView({
    super.key,
    this.itemCount = 5,
    this.showLabel = true,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, mainAxisSpacing: 10),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) => PickImageTile(
          size: size,
          label: showLabel == false
              ? null
              : index == 0
                  ? "Main"
                  : "${index + 1}",
          index: index,
        ),
      ),
    );
  }
}
