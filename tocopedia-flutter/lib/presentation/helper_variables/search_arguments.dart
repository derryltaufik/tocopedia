import 'package:tocopedia/domains/entities/category.dart';
import 'package:tocopedia/presentation/helper_variables/sort_selection_enum.dart';

class SearchArguments {
  String? sellerId;
  String? searchQuery;
  Category? category;
  int? minimumPrice;
  int? maximumPrice;
  SortSelection? sortSelection;

  SearchArguments(
      {this.sellerId,
      this.searchQuery,
      this.category,
      this.minimumPrice,
      this.maximumPrice,
      this.sortSelection});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchArguments &&
          runtimeType == other.runtimeType &&
          sellerId == other.sellerId &&
          searchQuery == other.searchQuery &&
          category == other.category &&
          minimumPrice == other.minimumPrice &&
          maximumPrice == other.maximumPrice &&
          sortSelection == other.sortSelection;

  @override
  int get hashCode =>
      sellerId.hashCode ^
      searchQuery.hashCode ^
      category.hashCode ^
      minimumPrice.hashCode ^
      maximumPrice.hashCode ^
      sortSelection.hashCode;

  SearchArguments copyWith({
    String? sellerId,
    String? searchQuery,
    Category? category,
    int? minimumPrice,
    int? maximumPrice,
    SortSelection? sortSelection,
  }) {
    return SearchArguments(
      sellerId: sellerId ?? this.sellerId,
      searchQuery: searchQuery ?? this.searchQuery,
      category: category ?? this.category,
      minimumPrice: minimumPrice ?? this.minimumPrice,
      maximumPrice: maximumPrice ?? this.maximumPrice,
      sortSelection: sortSelection ?? this.sortSelection,
    );
  }
}
