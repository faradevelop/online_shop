part of 'order_bloc.dart';

@immutable
sealed class OrderState {}

class OrderLoading extends OrderState {}

class OrderError extends OrderState {
  final AppException appException;

  OrderError(this.appException);
}

class OrderSuccess extends OrderState {
  final List<AddressEntity> addresses;
  final List<ProvinceEntity> provinces;

  OrderSuccess(this.addresses, this.provinces);
}

class OrderCreateLoading extends OrderState {}

class OrderCreateSuccess extends OrderState {
  final String link;

  OrderCreateSuccess(this.link);
}

class OrderCreateError extends OrderState {
  final AppException appException;

  OrderCreateError(this.appException);
}



class OrderListSuccess extends OrderState {
  final List<OrderEntity> orders;

  OrderListSuccess(this.orders);
}

class OrderListError extends OrderState {
  final AppException appException;

  OrderListError(this.appException);
}
