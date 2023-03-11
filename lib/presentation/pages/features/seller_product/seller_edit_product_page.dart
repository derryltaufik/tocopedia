import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/domains/entities/product.dart';
import 'package:tocopedia/presentation/helper_variables/future_function_handler.dart';
import 'package:tocopedia/presentation/pages/common_widgets/custom_form_field.dart';
import 'package:tocopedia/presentation/pages/common_widgets/images/pick_image_provider.dart';
import 'package:tocopedia/presentation/pages/common_widgets/images/pick_image_gridview.dart';
import 'package:tocopedia/presentation/pages/features/seller_product/widgets/category_dropdown.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';

class SellerEditProductPage extends StatefulWidget {
  static const String routeName = "seller/products/edit";
  final Product product;

  const SellerEditProductPage({Key? key, required this.product})
      : super(key: key);

  @override
  State<SellerEditProductPage> createState() => _SellerEditProductPageState();
}

class _SellerEditProductPageState extends State<SellerEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController(text: "1");
  final _skuController = TextEditingController();
  final _descriptionController = TextEditingController();
  Category? _selectedCategory;

  Future<void> submit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final newImages =
          Provider.of<PickImageProvider>(context, listen: false).newImages;
      final oldImages =
          Provider.of<PickImageProvider>(context, listen: false).oldImages;
      final name = _nameController.text;
      final price = _priceController.getInt()!;
      final stock = _stockController.getInt()!;
      final sku = _skuController.text;
      final description = _descriptionController.text;
      final categoryId = _selectedCategory!.id!;

      final updateProductFunction =
          Provider.of<ProductProvider>(context, listen: false).updateProduct(
              widget.product.id!,
              name: name,
              newImages: newImages,
              oldImages: oldImages,
              description: description,
              categoryId: categoryId,
              stock: stock,
              price: price,
              sku: sku);
      final product = await handleFutureFunction(
        context,
        loadingMessage: "Updating product...",
        successMessage: "Product successfully updated",
        function: updateProductFunction,
      );

      if (product != null && context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name ?? "";
    _stockController.text = widget.product.stock?.toString() ?? "";
    _skuController.text = widget.product.sku ?? "";
    _priceController.text =
        RupiahInputFormatter().format(widget.product.price.toString());
    _selectedCategory = widget.product.category;

    Future.microtask(() {
      Provider.of<ProductProvider>(context, listen: false)
          .getProduct(widget.product.id!)
          .then((value) => setState(
              () => _descriptionController.text = value?.description ?? ""));
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _skuController.dispose();
    _stockController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
      ),
      body: ChangeNotifierProvider<PickImageProvider>(
        create: (_) =>
            PickImageProvider(oldImages: widget.product.images ?? []),
        builder: (context, child) => SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Fill the name of product you sell *",
                    style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _nameController,
                  maxLength: 70,
                  minLength: 1,
                  labelText: "Product Name",
                ),
                const SizedBox(height: 10),
                Text("Product Images *", style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                const SizedBox(
                  height: 150,
                  child: PickImageGridView(),
                ),
                const SizedBox(height: 30),
                Text("Category *", style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                CategoryDropdown(
                    initialCategory: widget.product.category,
                    onChanged: (value) => _selectedCategory = value),
                const SizedBox(height: 10),
                Text("Price *", style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                CustomTextField.rupiah(
                  controller: _priceController,
                  labelText: "Product Price",
                  helperText:
                      "Tips: Decide price based on competitive market price",
                ),
                const SizedBox(height: 10),
                Text("Stock *", style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _stockController,
                  maxLength: 6,
                  minLength: 1,
                  labelText: "Stock",
                  keyboardInputType: TextInputType.number,
                ),
                CustomTextField(
                  controller: _skuController,
                  maxLength: 40,
                  labelText: "Optional: SKU (Stock Keeping Unit)",
                ),
                const SizedBox(height: 10),
                Text("Description *", style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _descriptionController,
                  minLength: 1,
                  maxLength: 2000,
                  labelText: "Description",
                  keyboardInputType: TextInputType.multiline,
                  maxLines: null,
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                          onPressed: () => submit(context),
                          child: const Text("Submit")),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
