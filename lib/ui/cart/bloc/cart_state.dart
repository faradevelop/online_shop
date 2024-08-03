part of 'cart_bloc.dart';

sealed class CartState  {
  const CartState();


}

class CartAuthRequired extends CartState {}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final CartDetailsResponse cartDetails;
  final CartItem? loadingItem;
  final bool isRefresh;

  const CartSuccess(this.cartDetails, this.loadingItem, {this.isRefresh=false});


}

class CartError extends CartState {
  final AppException exception;

  const CartError({required this.exception});

}

class CartEmpty extends CartState{

}


class AddToCartButtonLoading extends CartState {}

class AddToCartButtonSuccess extends CartState {
  final CartCountResponse cart;

  const AddToCartButtonSuccess(this.cart);
}

class AddToCartButtonError extends CartState {
  final AppException exception;

  const AddToCartButtonError({required this.exception});


}



