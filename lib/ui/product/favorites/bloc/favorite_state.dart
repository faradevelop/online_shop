part of 'favorite_bloc.dart';

@immutable
sealed class FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteSuccess extends FavoriteState {
  final List<ProductEntity> favorites;
  final ProductEntity? loadingItem;
  final bool? favorited;

  FavoriteSuccess(this.favorites, {this.loadingItem, this.favorited});
}

class FavoriteError extends FavoriteState {
  final AppException exception;

  FavoriteError({required this.exception});
}

class UpdateFavoriteButtonSuccess extends FavoriteState {
  final List<ProductEntity> favorites;
  final ProductEntity? loadingItem;
  final bool favorited;

  UpdateFavoriteButtonSuccess(this.favorites, this.favorited,
      {this.loadingItem });
}

class UpdateFavoriteButtonLoading extends FavoriteState {}

class UpdateFavoriteButtonError extends FavoriteState {
  final AppException exception;

  UpdateFavoriteButtonError({required this.exception});
}
