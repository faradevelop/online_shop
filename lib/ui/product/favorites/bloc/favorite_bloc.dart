import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:online_shop/common/exception.dart';
import 'package:online_shop/data/model/product.dart';
import 'package:online_shop/data/repository/product_repository.dart';

part 'favorite_event.dart';

part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final IProductRepository productRepository;

  FavoriteBloc(this.productRepository) : super(FavoriteLoading()) {
    on<FavoriteEvent>((event, emit) async {
      if (event is FavoriteStarted) {
        emit(FavoriteLoading());
        try {
          final favorites = await productRepository.getFavorites();
          emit(FavoriteSuccess(favorites));
        } catch (e) {
          emit(
              FavoriteError(exception: e is AppException ? e : AppException()));
        }
      } else if (event is UpdateFavoriteButtonClicked) {

        try {
          if (event.isFavoriteList) {
            if (state is FavoriteSuccess) {
              final successState = (state as FavoriteSuccess);
              final loadingItem = successState.favorites
                  .firstWhere((element) => event.id == element.id);

              emit(FavoriteSuccess(successState.favorites,
                  loadingItem: loadingItem));
            }
            await Future.delayed(Duration(milliseconds: 1000));

            final bool favorited =
                await productRepository.updateFavorites(event.id);
            final favorites = await productRepository.getFavorites();

            if (state is FavoriteSuccess) {
              final successState = (state as FavoriteSuccess);
              successState.favorites.removeWhere(
                      (element) => event.id == element.id);
              // emit(CartSuccess(successState.cartItemResponse, null));
              emit(FavoriteSuccess(favorites, favorited: favorited));
            }
          } else {
            emit(UpdateFavoriteButtonLoading());
            final bool favorited =
                await productRepository.updateFavorites(event.id);
            final favorites = await productRepository.getFavorites();
            emit(UpdateFavoriteButtonSuccess(favorites,  favorited));
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
