import 'package:online_shop/data/model/product.dart';

class CartDetailsResponse {
  int? totalItems;
  String? price;
  String? discountPrice;
  String? totalPrice;
  List<CartItem>? items;

  CartDetailsResponse(
      {this.totalItems,
      this.price,
      this.discountPrice,
      this.totalPrice,
      this.items});

  CartDetailsResponse.fromJson(Map<String, dynamic> json) {
    totalItems = json['total_items'];
    price = json['price'];
    discountPrice = json['discount_price'];
    totalPrice = json['total_price'];
    if (json['items'] != null) {
      items = <CartItem>[];
      json['items'].forEach((v) {
        items!.add( CartItem.fromJson(v));
      });
    }
  }
}

class CartItem {
  int? count;
  ProductEntity? product;

  CartItem({this.count, this.product});

  CartItem.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    product = json['product'] != null
        ? ProductEntity.fromJson(json['product'])
        : null;
  }
}
