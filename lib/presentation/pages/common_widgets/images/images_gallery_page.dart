import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImagesGalleryPageArguments {
  final List<String> images;
  final int? startingIndex;

  ImagesGalleryPageArguments({required this.images, this.startingIndex});
}

class ImagesGalleryPage extends StatefulWidget {
  static const String routeName = "gallery";

  final List<String> images;
  final int startingIndex;
  final PageController _pageController;

  ImagesGalleryPage({
    super.key,
    required this.images,
    this.startingIndex = 0,
  }) : _pageController = PageController(initialPage: startingIndex);

  @override
  State<ImagesGalleryPage> createState() => _ImagesGalleryPageState();
}

class _ImagesGalleryPageState extends State<ImagesGalleryPage> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.startingIndex;
  }

  void updateIndex(int index) {
    setState(() {
      _index = index;
      widget._pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            PhotoViewGallery.builder(
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (BuildContext context, int index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider:
                      CachedNetworkImageProvider(widget.images[index]),
                  initialScale: PhotoViewComputedScale.contained,
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.contained * 2,
                  heroAttributes:
                      PhotoViewHeroAttributes(tag: widget.images[index]),
                );
              },
              itemCount: widget.images.length,
              loadingBuilder: (context, event) => Center(
                child: SizedBox(
                  width: 20.0,
                  height: 20.0,
                  child: CircularProgressIndicator(
                    value: event == null
                        ? 0
                        : event.cumulativeBytesLoaded /
                            event.expectedTotalBytes!,
                  ),
                ),
              ),
              pageController: widget._pageController,
              onPageChanged: updateIndex,
              backgroundDecoration: const BoxDecoration(color: Colors.black),
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                  )),
            ),
            Builder(
              builder: (context) {
                const size = 50.0;
                final images = widget.images;
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("${_index + 1}/${images.length}",
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: size + 16,
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => updateIndex(index),
                              child: Container(
                                width: size,
                                height: size,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                foregroundDecoration: BoxDecoration(
                                  border: index == _index
                                      ? Border.all(
                                          width: 1.5,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primaryContainer)
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: images[index],
                                  fit: BoxFit.cover,
                                  height: size,
                                  width: size,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
