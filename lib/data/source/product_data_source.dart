import 'package:dio/dio.dart';
import 'package:online_shop/common/http_client.dart';
import 'package:online_shop/common/http_response_validator.dart';
import 'package:online_shop/data/model/category.dart';
import 'package:online_shop/data/model/comment.dart';
import 'package:online_shop/data/model/product.dart';

abstract class IProductDataSource {
  Future<ProductEntity> getProductDetail({
    required int productId,
  });

  Future<List<ProductEntity>> getProducts({
    int? categoryId,
    String? searchTerm,
    String? orderColumn,
    String? orderType,
  });

  Future<List<CategoryEntity>> getCategories();

  Future<List<ProductEntity>> getFavorites();

  Future<bool> updateFavorites(int id);

  Future<List<CommentEntity>> getComment(int id);

  Future<bool> addComment(
    int id,
    int rate,
    String comment,
  );
}

class ProductRemoteDataSource
    with HttpResponseValidator
    implements IProductDataSource {
  final Dio httpclient;

  ProductRemoteDataSource({required this.httpclient});

  @override
  Future<List<ProductEntity>> getProducts({
    int? categoryId,
    String? searchTerm,
    String? orderColumn,
    String? orderType,
  }) async {
    Map<String, dynamic> parameters = {};
    if (categoryId != null) {
      parameters["category_id"] = categoryId.toString();
    }
    if (searchTerm != null) {
      parameters["keyword"] = searchTerm;
    }
    if (orderColumn != null) {
      parameters["order_column"] = orderColumn;
    }
    if (orderType != null) {
      parameters["order_type"] = orderType;
    }
    final res = await httpclient.get("/products", queryParameters: parameters);
    validateResponse(res);
    final products = <ProductEntity>[];
    for (var element in (res.data['data'] as List)) {
      products.add(ProductEntity.fromJson(element));
    }
    return products;
  }

  @override
  Future<ProductEntity> getProductDetail({required int productId}) async {
    final res = await httpclient.get("/products/${productId.toString()}");
    validateResponse(res);
    final ProductEntity product = ProductEntity.fromJson(res.data['data']);
    return product;
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final res = await httpclient.get("/categories");
    validateResponse(res);
    final categories = <CategoryEntity>[];
    for (var element in (res.data['data'] as List)) {
      categories.add(CategoryEntity.fromJson(element));
    }
    return categories;
  }

  @override
  Future<List<ProductEntity>> getFavorites() async {
    final res = await httpclient.get("/bookmarks");
    validateResponse(res);
    final products = <ProductEntity>[];
    for (var element in (res.data['data'] as List)) {
      products.add(ProductEntity.fromJson(element));
    }
    return products;
  }

  @override
  Future<bool> updateFavorites(int id) async {
    final res = await httpClient.post("/product/$id/bookmark");
    validateResponse(res);
    return res.data["bookmark"];
  }

  @override
  Future<List<CommentEntity>> getComment(int id) async {
    final res = await httpclient.get("/product/$id/reviews");
    validateResponse(res);
    final comments = <CommentEntity>[];
    for (var element in (res.data['data'] as List)) {
      comments.add(CommentEntity.fromJson(element));
    }
    return comments;
  }

  @override
  Future<bool> addComment(int id, int rate, String comment) async {
    final res = await httpClient.post("/review", data: {
      "product_id": id,
      "rate": rate,
      "comment": comment,
    });
    validateResponse(res);
    return res.statusCode == 200;
  }
}
