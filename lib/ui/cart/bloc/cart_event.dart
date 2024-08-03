part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartStarted extends CartEvent {
  final AuthInfo? authInfo;
  final bool isRefresh;

  const CartStarted(this.authInfo, {this.isRefresh = false});
}

class CartAuthInfoChanged extends CartEvent {
  final AuthInfo? authInfo;

  const CartAuthInfoChanged(this.authInfo);
}

class ProductAddButtonClicked extends CartEvent {
  final int productId;
  final bool increment;

  const ProductAddButtonClicked(this.productId, this.increment);
}

class CartDeleteButtonClicked extends CartEvent {
  final int productId;

  const CartDeleteButtonClicked(this.productId);

  @override
  List<Object?> get props => [productId];
}

class ChangeCartItemCount extends CartEvent {
  final int productId;
  final bool increment;

  const ChangeCartItemCount(this.productId, this.increment);
}
