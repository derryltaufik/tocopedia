import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/presentation/pages/common_widgets/home_appbar.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';
import 'package:tocopedia/presentation/providers/provider_state.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = "products/view";

  final String productId;

  const ViewProductPage({Key? key, required this.productId}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false)
          .getProduct(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: HomeAppBar(),
      body:
          Consumer<ProductProvider>(builder: (context, productProvider, child) {
        if (productProvider.getProductState == ProviderState.loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (productProvider.getProductState == ProviderState.error) {
          return Center(child: Text(productProvider.message));
        }
        final Product product = productProvider.product!;
        return Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductImagePreview(images: product.images),
                  Text(NumberFormat.currency(
                          decimalDigits: 0, locale: "id_ID", symbol: "Rp")
                      .format(product.price)),
                  Text(product.name),
                  Divider(),
                  Text(
                      "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth, the master-builder of human happiness. No one rejects, dislikes, or avoids pleasure itself, because it is pleasure, but because those who do not know how to pursue pleasure rationally encounter consequences that are extremely painful. Nor again is there anyone who loves or pursues or desires to obtain pain of itself, because it is pain, but because occasionally circumstances occur in which toil and pain can procure him some great pleasure. To take a trivial example, which of us ever undertakes laborious physical exercise, except to obtain some advantage from it? But who has any right to find fault with a man who chooses to enjoy a pleasure that has no annoying consequences, or one who avoids a pain that produces no resultant pleasure?"),
                  SizedBox(height: 60),
                ],
              ),
            ),
            Material(
              elevation: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                child: FilledButton.icon(
                  icon: Icon(Icons.add_shopping_cart_rounded),
                  label: Text(
                    "Add To Cart",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class ProductImagePreview extends StatefulWidget {
  final List<String> images;

  const ProductImagePreview({Key? key, required this.images}) : super(key: key);

  @override
  State<ProductImagePreview> createState() => _ProductImagePreviewState();
}

class _ProductImagePreviewState extends State<ProductImagePreview> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomStart,
      children: [
        CarouselSlider.builder(
          itemCount: widget.images.length,
          itemBuilder: (context, index, realIndex) {
            return Image.network(widget.images[index]);
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
