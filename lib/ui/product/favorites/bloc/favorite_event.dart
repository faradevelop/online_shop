part of 'favorite_bloc.dart';

@immutable
sealed class FavoriteEvent {}



class FavoriteStarted extends FavoriteEvent {}


class UpdateFavoriteButtonClicked extends FavoriteEvent {
  final int id;
  final bool isFavoriteList;

  UpdateFavoriteButtonClicked(this.id, this.isFavoriteList);
}


