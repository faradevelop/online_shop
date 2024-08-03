import 'package:online_shop/data/model/category.dart';
import 'package:online_shop/data/model/product.dart';

class HomeResponse {
  List<String>? sliders;
  List<CategoryEntity>? categories;
  List<ProductEntity>? discountedProducts;
  List<ProductEntity>? latestProducts;

  HomeResponse(
      {this.sliders,
        this.categories,
        this.discountedProducts,
        this.latestProducts});

  HomeResponse.fromJson(Map<String, dynamic> json) {

    if (json['sliders'] != null) {
      sliders = json['sliders'].cast<String>();
    }
    if (json['categories'] != null) {
      categories = <CategoryEntity>[];
      json['categories'].forEach((v) {
        categories!.add(CategoryEntity.fromJson(v));
      });
    }
    if (json['discounted_products'] != null) {
      discountedProducts = <ProductEntity>[];
      json['discounted_products'].forEach((v) {
        discountedProducts!.add(ProductEntity.fromJson(v));
      });
    }
    if (json['latest_products'] != null) {
      latestProducts = <ProductEntity>[];
      json['latest_products'].forEach((v) {
        latestProducts!.add(ProductEntity.fromJson(v));
      });
    }
  }
}
