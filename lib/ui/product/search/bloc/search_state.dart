part of 'search_bloc.dart';

sealed class SearchState {
  const SearchState();
}

final class ProductListLoading extends SearchState {
  final bool? loadingAll;

  ProductListLoading({this.loadingAll});
}

class ProductListSuccess extends SearchState {
  final List<CategoryEntity> categories;
  final List<ProductEntity> products;
  final bool isLoadingList;

  const ProductListSuccess(this.categories, this.products,
      {this.isLoadingList = false});
}

class ProductListError extends SearchState {
  final AppException exception;

  const ProductListError({required this.exception});


}
