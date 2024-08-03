import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:online_shop/common/exception.dart';
import 'package:online_shop/data/repository/cart_repository.dart';
import 'package:online_shop/data/response/auth_info_response.dart';
import 'package:online_shop/data/response/cart_details_response.dart';
import 'package:online_shop/data/response/cart_count_response.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final ICartRepository cartRepository;

  CartBloc(this.cartRepository) : super(CartLoading()) {
    on<CartEvent>((event, emit) async {
      if (event is CartStarted) {
        final authInfo = event.authInfo;
        if (authInfo == null || authInfo.token.isEmpty) {
          emit(CartAuthRequired());
        } else {
          await loadCartItems(emit, event.isRefresh);
        }
      } else if (event is CartAuthInfoChanged) {
        if (event.authInfo == null || event.authInfo!.token.isEmpty) {
          emit(CartAuthRequired());
        } else {
          if (state is CartAuthRequired) {
            await loadCartItems(emit, false);
          }
        }
      } else if (event is ProductAddButtonClicked) {
        emit(AddToCartButtonLoading());
        try {
          final cartResponse =
              await cartRepository.addToCart(event.productId, event.increment);
          await cartRepository.getCart();
          emit(AddToCartButtonSuccess(cartResponse));
        } catch (e) {
          emit(AddToCartButtonError(
              exception: e is AppException ? e : AppException()));
        }
      } else if (event is CartDeleteButtonClicked) {
        try {
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final loadingItem = successState.cartDetails.items?.firstWhere(
                (element) => event.productId == element.product!.id);
            emit(CartSuccess(successState.cartDetails, loadingItem));
          }
          await Future.delayed(const Duration(milliseconds: 1000));
          await cartRepository.addToCart(event.productId, false, delete: true);
          final cartItemResponse = await cartRepository.getCart();

          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            successState.cartDetails.items?.removeWhere(
                (element) => event.productId == element.product!.id);
            if (successState.cartDetails.items!.isEmpty) {
              emit(CartEmpty());
            } else {
              // emit(CartSuccess(successState.cartItemResponse, null));
              emit(CartSuccess(cartItemResponse, null));
            }
          }
        } catch (e) {
          print(e.toString());
        }
      } else if (event is ChangeCartItemCount) {
        try {
          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
            final loadingItem = successState.cartDetails.items?.firstWhere(
                    (element) => event.productId == element.product!.id);
            emit(CartSuccess(successState.cartDetails, loadingItem));
          }

          await cartRepository.addToCart(event.productId,  event.increment);
          final cartItemResponse = await cartRepository.getCart();

          if (state is CartSuccess) {
            final successState = (state as CartSuccess);
          /*  successState.cartItemResponse.items?.firstWhere(
                    (element) => event.productId == element.product!.id);*/
            if (successState.cartDetails.items!.isEmpty) {
              emit(CartEmpty());
            } else {
              // emit(CartSuccess(successState.cartItemResponse, null));
              emit(CartSuccess(cartItemResponse, null));
            }
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }

  Future<void> loadCartItems(
      Emitter<CartState> emitter, bool isRefreshing) async {
    try {
      if (!isRefreshing) {
        emitter(CartLoading());
      }
      final cartItems = await cartRepository.getCart();
      final items = cartItems.items ?? [];
      if (items.isEmpty) {
        emitter(CartEmpty());
      } else {
        emitter(CartSuccess(cartItems, null, isRefresh: isRefreshing));
      }
    } catch (e) {
      emitter(CartError(exception: AppException()));
    }
  }
}
