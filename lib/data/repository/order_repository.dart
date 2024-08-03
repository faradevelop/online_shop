import 'package:online_shop/common/http_client.dart';
import 'package:online_shop/data/model/order.dart';
import 'package:online_shop/data/response/order_response.dart';
import 'package:online_shop/data/source/order_data_source.dart';

final orderRepository = OrderRepository(OrderRemoteDataSource(httpClient));

abstract class IOrderRepository {
  Future<OrderResponse> createOrder(
      int addressId, int shipping, String platform);

  Future<List<OrderEntity>> getOrders();
}

class OrderRepository implements IOrderRepository {
  final IOrderDataSource dataSource;

  OrderRepository(this.dataSource);

  @override
  Future<OrderResponse> createOrder(
      int addressId, int shipping, String platform) {
    return dataSource.createOrder(addressId, shipping, platform);
  }

  @override
  Future<List<OrderEntity>> getOrders() {
    return dataSource.getOrders();
  }
}
