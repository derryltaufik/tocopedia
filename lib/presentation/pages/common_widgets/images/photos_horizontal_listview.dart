import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'images_gallery_page.dart';

class PhotosHorizontalListView extends StatelessWidget {
  const PhotosHorizontalListView({
    super.key,
    required this.images,
    this.size = 100,
  });

  final List<String> images;
  final double size;

  @override
  Widget build(BuildContext context) {
    // var list = <Widget>[];
    // for (var image in images) {
    //   list.add(Padding(
    //     padding: const EdgeInsets.all(8.0).copyWith(left: 0),
    //     child: Container(
    //       width: size,
    //       height: size,
    //       clipBehavior: Clip.antiAlias,
    //       decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(10),
    //         color: Colors.black12,
    //       ),
    //       child: CachedNetworkImage(
    //         imageUrl: image,
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //   ));
    // }
    //
    // return SingleChildScrollView(
    //   scrollDirection: Axis.horizontal,
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: list,
    //   ),
    // );
    return SizedBox(
      height: size + 16,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                ImagesGalleryPage.routeName,
                arguments: ImagesGalleryPageArguments(
                    images: images, startingIndex: index),
              ),
              child: Container(
                width: size,
                height: size,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                ),
                child: CachedNetworkImage(
                  imageUrl: images[index],
                  fit: BoxFit.cover,
                  height: size,
                  width: size,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
