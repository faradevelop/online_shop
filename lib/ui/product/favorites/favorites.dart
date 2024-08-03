import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop/data/model/product.dart';
import 'package:online_shop/data/repository/product_repository.dart';
import 'package:online_shop/ui/product/favorites/bloc/favorite_bloc.dart';
import 'package:online_shop/ui/product/product_detail.dart';
import 'package:online_shop/ui/product/search/products.dart';
import 'package:online_shop/ui/widgets/appbar_widget.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';
import 'package:online_shop/ui/widgets/empty_view.dart';
import 'package:online_shop/ui/widgets/favorite_item.dart';
import 'package:online_shop/ui/widgets/loading_widget.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = FavoriteBloc(productRepository);
        bloc.add(FavoriteStarted());
        return bloc;
      },
      child: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is FavoriteSuccess) {
            return Column(
              children: [
                AppbarWidget(
                  title: 'علاقه مندی ها',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Products(
                        defaultSortId: 1,
                      ),
                    ));
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ValueListenableBuilder<List<ProductEntity>>(
                    valueListenable: ProductRepository.favoriteListNotifier,
                    builder: (context, value, child) {
                      return value.isEmpty?const EmptyView(message: "محصولی یافت نشد") : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: value.length + 1,
                        itemBuilder: (context, index) {
                          return index < value.length
                              ? Padding(
                                  padding:
                                      EdgeInsets.only(top: index == 0 ? 4 : 0),
                                  child: FavoriteItem(
                                    loading: state.loadingItem?.id==value[index].id,
                                    icon: CupertinoIcons.heart_fill,
                                    item: value[index],
                                    onFavorite: () {
                                      BlocProvider.of<FavoriteBloc>(context)
                                          .add(UpdateFavoriteButtonClicked(
                                              value[index].id!, true));
                                    },
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ProductDetail(
                                            productId: value[index].id!),
                                      ));
                                    },
                                  ),
                                )
                              : Container(
                                  height: 40,
                                );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is FavoriteLoading) {
            return const LoadingWidget();
          } else if (state is FavoriteError) {
            return EmptyView(
                message: "خطای نامشخص",
                callToAction: ButtonWidget(
                    text: 'تلاش مجدد',
                    onPressed: () {
                      BlocProvider.of<FavoriteBloc>(context)
                          .add(FavoriteStarted());
                    }));
          } else {
            throw Exception('State is not supported');
          }
        },
      ),
    );
  }
}
