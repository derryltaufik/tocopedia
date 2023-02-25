import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/presentation/helper_variables/search_arguments.dart';
import 'package:tocopedia/presentation/helper_variables/sort_selection_enum.dart';
import 'package:tocopedia/presentation/pages/common_widgets/rupiah_text_field.dart';
import 'package:tocopedia/presentation/providers/product_provider.dart';


//https://web.archive.org/web/20230225174447/https://appunite.com/blog/how-to-scroll-your-bottom-sheet-differently-with-flutter

Future<SearchArguments?> showFilterBottomSheet(
    BuildContext context, SearchArguments searchArguments) {
  return showModalBottomSheet<SearchArguments>(
    context: context,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      snap: true,
      snapSizes: const [0.5, 0.9],
      expand: false,
      builder: (context, scrollController) {
        return FilterBottomSheet(
          context: context,
          scrollController: scrollController,
          initialSearchArguments: searchArguments,
        );
      },
    ),

  );
}

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({
    super.key,
    required this.scrollController,
    required this.context,
    required this.initialSearchArguments,

  });

  final ScrollController scrollController;
  final BuildContext context;
  final SearchArguments initialSearchArguments;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late final Set<Category> categorySelection;

  SortSelection? selectedSort;
  Category? selectedCategory;
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedSort = widget.initialSearchArguments.sortSelection;
    selectedCategory = widget.initialSearchArguments.category;
    if (widget.initialSearchArguments.minimumPrice != null) {
      // https://github.com/flutter/flutter/issues/30369
      minPriceController.text = RupiahInputFormatter()
          .format(widget.initialSearchArguments.minimumPrice.toString());
    }
    if (widget.initialSearchArguments.maximumPrice != null) {
      maxPriceController.text = RupiahInputFormatter()
          .format(widget.initialSearchArguments.minimumPrice.toString());
    }
    categorySelection = Provider.of<ProductProvider>(context, listen: false)
        .getSearchedProductCategories();
  }

  void applyFilter() {
    final minPrice =
        int.tryParse(minPriceController.text.replaceAll(RegExp(r"\D"), ""));
    final maxPrice =
        int.tryParse(maxPriceController.text.replaceAll(RegExp(r"\D"), ""));

    final searchArguments = SearchArguments(
      maximumPrice: maxPrice,
      minimumPrice: minPrice,
      category: selectedCategory,
      sortSelection: selectedSort,
    );
    Navigator.of(context).pop(searchArguments);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      controller: widget.scrollController,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text("Filter",
                style: theme.textTheme.titleLarge!
                    .copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Text("Sort By",
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: SortSelection.values.map((SortSelection sort) {
                return FilterChip(
                  label: Text(sort.description),
                  selected: selectedSort == sort,
                  onSelected: (bool value) => setState(
                    () {
                      if (value) {
                        selectedSort = sort;
                      }
                    },
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Text("Price",
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Row(
              children: [
                Flexible(
                  child: RupiahTextField(
                    controller: minPriceController,
                    label: "Lowest",
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: RupiahTextField(
                    controller: maxPriceController,
                    label: "Highest",
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text("Category",
                style: theme.textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: categorySelection.map((Category category) {
                return FilterChip(
                  label: Text(category.name!),
                  selected: selectedCategory == category,
                  onSelected: (bool value) => setState(
                    () {
                      if (value) selectedCategory = category;
                    },
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  child: Text("Apply Filter"),
                  onPressed: () => applyFilter(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension on TextInputFormatter {
  String format(String text) {
    return formatEditUpdate(
      const TextEditingValue(),
      TextEditingValue(
        text: text,
        selection: TextSelection(
          baseOffset: text.length,
          extentOffset: text.length,
        ),
      ),
    ).text;
  }
}

