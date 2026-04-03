import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/presentation/providers/category_provider.dart';

class CategoryDropdown extends StatefulWidget {
  const CategoryDropdown({Key? key, this.onChanged, this.initialCategory})
      : super(key: key);
  final Function(Category? value)? onChanged;
  final Category? initialCategory;

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  @override
  void initState() {
    super.initState();
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    if (categoryProvider.allCategories == null ||
        categoryProvider.allCategories!.isEmpty) {
      Future.microtask(() {
        categoryProvider.getAllCategories();
      });
    }
  }

  Category? dropdownValue;

  @override
  Widget build(BuildContext context) {
    final categoryList = Provider.of<CategoryProvider>(context).allCategories;
    if (widget.initialCategory != null) {
      dropdownValue = categoryList
          ?.firstWhere((element) => element.id == widget.initialCategory!.id);
    }
    return DropdownButtonFormField<Category>(
      value: dropdownValue,
      validator: (value) {
        if (value == null) return "Select category";
        return null;
      },
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontWeight: FontWeight.normal),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black26),
        ),
      ),
      items: categoryList?.map<DropdownMenuItem<Category>>((Category value) {
        return DropdownMenuItem<Category>(
          value: value,
          child: Row(
            children: [
              CachedNetworkImage(
                imageUrl: value.image!,
                height: 30,
                width: 30,
                progressIndicatorBuilder: (_, __, downloadProgress) => Center(
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              const SizedBox(width: 10),
              Text(value.name ?? ""),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
        setState(() => dropdownValue = value);
      },
    );
  }
}
