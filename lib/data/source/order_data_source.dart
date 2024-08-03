import 'package:dio/dio.dart';
import 'package:online_shop/common/http_response_validator.dart';
import 'package:online_shop/data/model/order.dart';
import 'package:online_shop/data/response/order_response.dart';

abstract class IOrderDataSource {
  Future<OrderResponse> createOrder(
      int addressId, int shipping, String platform);

  Future<List<OrderEntity>> getOrders();
}

class OrderRemoteDataSource
    with HttpResponseValidator
    implements IOrderDataSource {
  final Dio httpclient;

  OrderRemoteDataSource(this.httpclient);

  @override
  Future<OrderResponse> createOrder(
      int addressId, int shipping, String platform) async {
    final res = await httpclient.post("/order", data: {
      "address_id": addressId,
      "shipping_method": shipping,
      "platform": platform,
    });
    validateResponse(res);
    return OrderResponse.fromJson(res.data);
  }

  @override
  Future<List<OrderEntity>> getOrders() async {
    final res = await httpclient.get("/order");
    validateResponse(res);
    final orderList = <OrderEntity>[];
    for (var element in (res.data['data'] as List)) {
      orderList.add(OrderEntity.fromJson(element));
    }
    return orderList;
  }
}

class ShippingMethod {
  static int tipax = 1;
  static int post = 2;
}
