import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/common/constants.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/presentation/pages/common_widgets/home_appbar.dart';
import 'package:tocopedia/presentation/pages/features/product/widgets/add_to_cart_button.dart';
import 'package:tocopedia/presentation/pages/features/product/widgets/product_image_carousel.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';
import 'package:tocopedia/presentation/helper_variables/provider_state.dart';

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
        if (productProvider.getProductState == ProviderState.loading ||
            productProvider.getProductState == ProviderState.empty) {
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
            SizedBox(
              height: double.infinity,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProductImageCarousel(images: product.images!),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                rupiahFormatter.format(product.price),
                                style: theme.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.favorite_outline_rounded)),
                            ],
                          ),
                          Text(
                            product.name!,
                            style: theme.textTheme.bodyLarge,
                          ),
                          if (product.totalSold! > 0)
                            Text(
                              "Sold ${NumberFormat.decimalPattern("id_ID").format(product.totalSold)}",
                              style: theme.textTheme.bodyMedium!
                                  .copyWith(color: Colors.black54),
                            ),
                        ],
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Product Description",
                              style: theme.textTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text(product.description!),
                        ],
                      ),
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ),
            ),
            AddToCartButton(productId: product.id!),
          ],
        );
      }),
    );
  }
}
