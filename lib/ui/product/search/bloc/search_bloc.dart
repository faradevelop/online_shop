import 'package:bloc/bloc.dart';
import 'package:online_shop/common/exception.dart';
import 'package:online_shop/data/model/category.dart';
import 'package:online_shop/data/model/product.dart';
import 'package:online_shop/data/repository/product_repository.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final IProductRepository productRepository;

  SearchBloc(this.productRepository) : super(ProductListLoading()) {
    on<SearchEvent>((event, emit) async {
      if (event is ProductListStarted) {
        emit(ProductListLoading(loadingAll: true));
        try {
          final categories = await productRepository.getCategories();
          final products = await productRepository.getProducts(
            categoryId: event.category?.id,
            orderType: event.sort?.orderType,
            orderColumn: event.sort?.orderBy,
            searchTerm: event.searchTerm,
          );

          emit(ProductListSuccess(categories, products));
        } catch (e) {
          emit(ProductListError(
              exception: e is AppException ? e : AppException()));
        }
      } else if (event is SearchListStarted) {
        try {
          if (state is ProductListSuccess) {
            final successState = (state as ProductListSuccess);

            emit(ProductListSuccess(
                successState.categories, successState.products,
                isLoadingList: true));
          }
          await Future.delayed(const Duration(milliseconds: 1000));
          final products = await productRepository.getProducts(
            categoryId: event.category?.id,
            orderType: event.sort?.orderType,
            orderColumn: event.sort?.orderBy,
            searchTerm: event.searchTerm,
          );

          if (state is ProductListSuccess) {
            final successState = (state as ProductListSuccess);

            emit(ProductListSuccess(successState.categories, products,
                isLoadingList: false));
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }
}
