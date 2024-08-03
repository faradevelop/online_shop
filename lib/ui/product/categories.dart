import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop/data/repository/product_repository.dart';
import 'package:online_shop/ui/product/bloc/product_bloc.dart';
import 'package:online_shop/ui/product/search/products.dart';
import 'package:online_shop/ui/widgets/appbar_widget.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';
import 'package:online_shop/ui/widgets/category_item_widget.dart';
import 'package:online_shop/ui/widgets/empty_view.dart';
import 'package:online_shop/ui/widgets/loading_widget.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ProductBloc(productRepository: productRepository);
        bloc.add(ProductCategoriesStarted());
        return bloc;
      },
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductCategoriesSuccess) {
            return Column(
              children: [
                AppbarWidget(
                  title: 'دسته بندی ها',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Products(defaultSortId: 1,),
                    ));
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.75,
                      crossAxisCount: MediaQuery.of(context).size.width ~/ 105,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 18,
                    ),
                    itemCount: state.categories.length + 4,
                    itemBuilder: (context, index) {
                      return index < state.categories.length
                          ? Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: CategoryItemWidget(
                                category: state.categories[index],
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => Products(
                                        defaultSortId: 1,
                                        category: state.categories[index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container();
                    },
                  ),
                ),
              ],
            );
          } else if (state is Loading) {
            return const LoadingWidget();
          } else if (state is ProductCategoriesError) {
            return EmptyView(
                message: "خطای نامشخص",
                callToAction: ButtonWidget(
                    text: 'تلاش مجدد',
                    onPressed: () {
                      BlocProvider.of<ProductBloc>(context)
                          .add(ProductCategoriesStarted());
                    }));
          } else {
            throw Exception('State is not supported');
          }
        },
      ),
    );
  }
}
