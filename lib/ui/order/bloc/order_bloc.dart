import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:online_shop/common/exception.dart';
import 'package:online_shop/data/model/address.dart';
import 'package:online_shop/data/model/order.dart';
import 'package:online_shop/data/repository/order_repository.dart';
import 'package:online_shop/data/repository/profile_repository.dart';

part 'order_event.dart';

part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final IOrderRepository orderRepository;
  final IProfileRepository profileRepository;

  OrderBloc(this.orderRepository, this.profileRepository)
      : super(OrderLoading()) {
    on<OrderEvent>((event, emit) async {
      if (event is OrderStarted) {
        try {
          emit(OrderLoading());
          final addresses = await profileRepository.getAddresses();
          final provinces = await profileRepository.getProvinces();

          emit(OrderSuccess(addresses, provinces));
        } catch (e) {
          emit(OrderError(AppException()));
        }
      } else if (event is OrderCreate) {
        try {
          emit(OrderCreateLoading());
          final res = await orderRepository.createOrder(
              event.addressId, event.shipping, "android");
          Future.delayed(const Duration(seconds: 10));
          emit(OrderCreateSuccess(res.paymentLink ?? ""));
        } catch (e) {
          emit(OrderCreateError(AppException()));
        }
      } else if (event is OrderListStarted) {
        emit(OrderLoading());
        try {
          final orders = await orderRepository.getOrders();

          emit(OrderListSuccess(orders));
        } catch (e) {
          emit(OrderListError(AppException()));
        }
      }
    });
  }
}
