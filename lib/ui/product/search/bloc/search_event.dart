part of 'search_bloc.dart';

sealed class SearchEvent {
  const SearchEvent();
}

class ProductListStarted extends SearchEvent {
  final CategoryEntity? category;
  final Sort? sort;
  final String? searchTerm;

  ProductListStarted( {this.category, this.sort,this.searchTerm});
}


class SearchListStarted extends SearchEvent {
  final CategoryEntity? category;
  final Sort? sort;
  final String? searchTerm;

  SearchListStarted( {this.category, this.sort,this.searchTerm});
}


