import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/presentation/pages/features/seller_product/providers/pick_image_provider.dart';
import 'package:tocopedia/presentation/pages/features/seller_product/widgets/pick_image_gridview.dart';

class SellerAddProductPage extends StatelessWidget {
  static const String routeName = "seller/products/add";

  const SellerAddProductPage({Key? key}) : super(key: key);

  void submit(BuildContext context) {
    final images =
        Provider.of<PickImageProvider>(context, listen: false).images;
    print(images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
      ),
      body: ChangeNotifierProvider<PickImageProvider>(
        create: (_) => PickImageProvider(),
        builder: (context, child) => SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 150,
                child: PickImageGridView(),
              ),
              Row(
                children: [
                  FilledButton(
                      onPressed: () => submit(context), child: Text("Submit"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
