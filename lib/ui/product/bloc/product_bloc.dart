import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:online_shop/common/exception.dart';
import 'package:online_shop/data/model/category.dart';
import 'package:online_shop/data/model/product.dart';
import 'package:online_shop/data/repository/product_repository.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final IProductRepository productRepository;


  ProductBloc({
    required this.productRepository,
  }) : super(Loading()) {
    on<ProductEvent>((event, emit) async {
      if (event is ProductStarted) {
        emit(Loading());
        try {
          final productDetails = await productRepository.getProductDetail(
              productId: event.productId);
          emit(ProductSuccess(product: productDetails));
        } catch (e) {
          emit(ProductError(exception: e is AppException ? e : AppException()));
        }
      }else if (event is ProductCategoriesStarted){
        try {
          emit(Loading());
          final categories = await productRepository.getCategories();
          emit(ProductCategoriesSuccess(categories));
        } catch (e) {
          emit(ProductCategoriesError(exception: e is AppException ? e : AppException()));
        }
      }else if (event is ProductFavoriteStarted){
        try {
          emit(Loading());
          final favorites = await productRepository.getFavorites();

          emit(ProductFavoriteSuccess(favorites));
        } catch (e) {
          emit(ProductFavoriteError(exception: e is AppException ? e : AppException()));
        }
      }
    });
  }
}
