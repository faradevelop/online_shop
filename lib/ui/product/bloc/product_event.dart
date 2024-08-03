part of 'product_bloc.dart';

@immutable
sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class ProductStarted extends ProductEvent {
  final int productId;

  const ProductStarted({required this.productId});
}

class ProductCategoriesStarted extends ProductEvent {}

class ProductFavoriteStarted extends ProductEvent {}


