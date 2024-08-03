part of 'home_bloc.dart';

@immutable
sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<String> banners;
  final List<CategoryEntity> categories;
  final List<ProductEntity> discountedProducts;
  final List<ProductEntity> latestProducts;

  const HomeSuccess(
      {required this.banners,
      required this.categories,
      required this.discountedProducts,
      required this.latestProducts});
}

class HomeError extends HomeState {
  final AppException exception;

  const HomeError({required this.exception});

  @override
  List<Object> get props => [exception];
}
