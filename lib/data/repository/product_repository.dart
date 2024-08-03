
import 'package:flutter/cupertino.dart';
import 'package:online_shop/common/http_client.dart';
import 'package:online_shop/data/model/category.dart';
import 'package:online_shop/data/model/comment.dart';
import 'package:online_shop/data/model/product.dart';
import 'package:online_shop/data/source/product_data_source.dart';

final productRepository =
    ProductRepository(ProductRemoteDataSource(httpclient: httpClient));

abstract class IProductRepository {
  Future<List<ProductEntity>> getProducts({
    int? categoryId,
    String? searchTerm,
    String? orderColumn,
    String? orderType,
  });

  Future<ProductEntity> getProductDetail({
    required int productId,
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

class ProductRepository implements IProductRepository {
  final IProductDataSource dataSource;

  ProductRepository(this.dataSource);

  static ValueNotifier<List<ProductEntity>> favoriteListNotifier =
      ValueNotifier([]);

  @override
  Future<List<ProductEntity>> getProducts({
    int? categoryId,
    String? searchTerm,
    String? orderColumn,
    String? orderType,
  }) {
    return dataSource.getProducts(
      categoryId: categoryId,
      searchTerm: searchTerm,
      orderColumn: orderColumn,
      orderType: orderType,
    );
  }

  @override
  Future<ProductEntity> getProductDetail({required int productId}) {
    return dataSource.getProductDetail(productId: productId);
  }

  @override
  Future<List<CategoryEntity>> getCategories() {
    return dataSource.getCategories();
  }

  @override
  Future<List<ProductEntity>> getFavorites() async {
    final List<ProductEntity> favorites = await dataSource.getFavorites();
    favoriteListNotifier.value = favorites;
    return favorites;
  }

  @override
  Future<bool> updateFavorites(int id) async {
    return dataSource.updateFavorites(id);
  }

  @override
  Future<List<CommentEntity>> getComment(int id) {
    return dataSource.getComment(id);
  }

  @override
  Future<bool> addComment(int id, int rate, String comment) {
    return dataSource.addComment(id, rate, comment);
  }
}
