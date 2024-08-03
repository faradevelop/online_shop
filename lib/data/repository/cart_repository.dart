


import 'package:flutter/cupertino.dart';
import 'package:online_shop/common/http_client.dart';
import 'package:online_shop/data/response/cart_details_response.dart';
import 'package:online_shop/data/response/cart_count_response.dart';
import 'package:online_shop/data/source/cart_data_source.dart';

final cartRepository = CartRepository(CartDataSource(httpClient));

abstract class ICartRepository {
  Future<CartCountResponse> addToCart(int productId, bool increment, {bool delete});

  Future<CartDetailsResponse> getCart();
}

class CartRepository implements ICartRepository {
  final ICartDataSource dataSource;
  static ValueNotifier<int> cartItemCountNotifier=ValueNotifier(0);

  CartRepository(this.dataSource);

  @override
  Future<CartCountResponse> addToCart(int productId, bool increment,
      {bool delete = false}) async {
    return dataSource.addToCart(productId, increment, delete);
  }

  @override
  Future<CartDetailsResponse> getCart() async {
    final cartItemResponse = await dataSource.getCart();
    final count = cartItemResponse.items ?? [];
    cartItemCountNotifier.value = count.length;
    return cartItemResponse;
  }
}
