enum SortSelection {
  reviews("Reviews", "average-rating", "desc"),
  mostSold("Most Sold", "total-sold", "desc"),
  newest("Newest", "created-date", "desc"),
  mostExpensive("Most Expensive", "price", "desc"),
  cheapest("Cheapest", "price", "asc");

  const SortSelection(
    this.description,
    this.sortBy,
    this.orderBy,
  );

  final String description;
  final String sortBy;
  final String orderBy;

}
