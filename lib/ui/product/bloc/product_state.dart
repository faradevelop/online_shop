part of 'product_bloc.dart';

@immutable
sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class Loading extends ProductState {}

class ProductSuccess extends ProductState {
  final ProductEntity product;

  const ProductSuccess({required this.product});
}

class ProductError extends ProductState {
  final AppException exception;

  const ProductError({required this.exception});

  @override
  List<Object> get props => [exception];
}

class ProductCategoriesSuccess extends ProductState {
  final List<CategoryEntity> categories;

  const ProductCategoriesSuccess(this.categories);
}

class ProductCategoriesError extends ProductState {
  final AppException exception;

  const ProductCategoriesError({required this.exception});

  @override
  List<Object> get props => [exception];
}

class ProductFavoriteSuccess extends ProductState {
  final List<ProductEntity> products;

  const ProductFavoriteSuccess(this.products);
}

class ProductFavoriteError extends ProductState {
  final AppException exception;

  const ProductFavoriteError({required this.exception});

  @override
  List<Object> get props => [exception];
}

