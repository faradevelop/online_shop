import 'package:online_shop/data/model/product.dart';

class OrderEntity {
  String? trackingCode;
  String? totalPrice;
  String? status;
  String? address;
  List<ProductEntity>? products;

  OrderEntity(
      {this.trackingCode,
        this.totalPrice,
        this.status,
        this.address,
        this.products});

  OrderEntity.fromJson(Map<String, dynamic> json) {
    trackingCode = json['tracking_code'];
    totalPrice = json['total_price'];
    status = json['status'];
    address = json['address'];
    if (json['products'] != null) {
      products = <ProductEntity>[];
      json['products'].forEach((v) {
        products!.add( ProductEntity.fromJson(v));
      });
    }
  }


}
