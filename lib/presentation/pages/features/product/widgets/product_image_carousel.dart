import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tocopedia/presentation/pages/common_widgets/images/images_gallery_page.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<String> images;

  const ProductImageCarousel({Key? key, required this.images})
      : super(key: key);

  @override
  State<ProductImageCarousel> createState() => _ProductImagePreviewState();
}

class _ProductImagePreviewState extends State<ProductImageCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        CarouselSlider.builder(
          itemCount: widget.images.length,
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(
                  ImagesGalleryPage.routeName,
                  arguments: ImagesGalleryPageArguments(
                      images: widget.images, startingIndex: index)),
              child: CachedNetworkImage(
                imageUrl: widget.images[index],
                progressIndicatorBuilder: (_, __, downloadProgress) => Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress)),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            );
          },
          options: CarouselOptions(
              viewportFraction: 1,
              aspectRatio: 1.0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) =>
                  setState(() => _currentIndex = index)),
        ),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10, left: 15),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                  child: Text(
                "${_currentIndex + 1}/${widget.images.length}",
                style: TextStyle(color: Colors.white),
              )),
            ),
          ],
        )
      ],
    );
  }
}
