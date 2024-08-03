import 'package:dio/dio.dart';
import 'package:online_shop/data/response/cart_details_response.dart';
import 'package:online_shop/data/response/cart_count_response.dart';

abstract class ICartDataSource {
  Future<CartCountResponse> addToCart(int productId, bool increment,bool delete );

  Future<CartDetailsResponse> getCart();
}

class CartDataSource implements ICartDataSource {
  final Dio httpClient;

  CartDataSource(this.httpClient);

  @override
  Future<CartCountResponse> addToCart(int productId, bool increment,bool delete ) async {
    final res = await httpClient.post("/add-to-cart", data: {
      "product_id": productId,
      "increment": increment,
      "delete": delete,
    });

    return CartCountResponse.fromJson(res.data);
  }

  @override
  Future<CartDetailsResponse> getCart() async {
    final res=await httpClient.get("/cart");
    return CartDetailsResponse.fromJson(res.data);
  }
}
