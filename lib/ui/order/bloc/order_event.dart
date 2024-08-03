part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

class OrderStarted extends OrderEvent {}

class OrderCreate extends OrderEvent {
  final int addressId;
  final int shipping;
  final String platform;

  OrderCreate(this.addressId, this.shipping, {this.platform = "android"});
}

class OrderListStarted extends OrderEvent {}
