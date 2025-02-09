import 'package:flutter/material.dart';

class ProductSearch extends SearchDelegate<String> {
  final List<String> categories;
  final Function(String) filterByCategory;

  ProductSearch(this.categories, this.filterByCategory);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ""; // Clear search query
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ""); // Close search bar
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (categories.contains(query)) {
      filterByCategory(query); // Filter by entered category
      close(context, query); // Close search and apply filter
    }
    return Container(); // No separate search result UI needed
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = categories
        .where(
            (category) => category.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(suggestionList[index]),
          onTap: () {
            query = suggestionList[index];
            filterByCategory(query); // Apply category filter
            close(context, query);
          },
        );
      },
    );
  }
}
