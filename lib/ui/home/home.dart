import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/data/repository/home_repository.dart';
import 'package:online_shop/ui/home/bloc/home_bloc.dart';
import 'package:online_shop/ui/product/product_detail.dart';
import 'package:online_shop/ui/product/search/products.dart';
import 'package:online_shop/ui/widgets/appbar_widget.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';
import 'package:online_shop/ui/widgets/category_item_widget.dart';
import 'package:online_shop/ui/widgets/loading_widget.dart';
import 'package:online_shop/ui/widgets/product_item_widget.dart';
import 'package:online_shop/ui/widgets/slider_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final homeBloc = HomeBloc(repository: homeRepository);
        homeBloc.add(HomeStarted());
        return homeBloc;
      },
      child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        if (state is HomeSuccess) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: 8,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return AppbarWidget(
                    logo: true,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Products(
                          defaultSortId: 1,
                        ),
                      ));
                    },
                  );

                case 1:
                  return Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: SliderWidget(images: state.banners),
                  );
                case 2:
                  return Padding(
                    padding: const EdgeInsets.only(top: 36),
                    child: _TitleWidget(
                      title: 'دسته بندی ها',
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Products(defaultSortId: 5),
                        ));
                      },
                    ),
                  );
                case 3:
                  return SizedBox(
                    height: 150,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        int count = state.categories.length;
                        return Padding(
                          padding: EdgeInsets.only(
                              left: index == count - 1 ? 18 : 15,
                              right: index == 0 ? 18 : 0),
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
                        );
                      },
                    ),
                  );
                case 4:
                  return Padding(
                    padding: const EdgeInsets.only(top: 26),
                    child: _TitleWidget(
                      title: 'تخفیف های شگفت انگیز',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Products(
                              defaultSortId: 2,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                case 5:
                  return SizedBox(
                    height: 210,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.discountedProducts.length,
                      itemBuilder: (context, index) {
                        int count = state.discountedProducts.length;
                        return Padding(
                          padding: EdgeInsets.only(
                              left: index == count - 1 ? 18 : 17,
                              right: index == 0 ? 18 : 0),
                          child: ProductItemWidget(
                            product: state.discountedProducts[index],
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetail(
                                    productId:
                                        state.discountedProducts[index].id!,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                case 6:
                  return Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: _TitleWidget(
                      title: 'جدیدترین محصولات',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Products(
                              defaultSortId: 1,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                case 7:
                  return SizedBox(
                    height: 210 + 40,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: state.latestProducts.length,
                      itemBuilder: (context, index) {
                        int count = state.latestProducts.length;
                        return Padding(
                          padding: EdgeInsets.only(
                              left: index == count - 1 ? 18 : 17,
                              right: index == 0 ? 18 : 0),
                          child: ProductItemWidget(
                            product: state.latestProducts[index],
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetail(
                                    productId: state.latestProducts[index].id!,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                default:
                  return Container();
              }
            },
          );
        } else if (state is HomeLoading) {
          return const LoadingWidget();
        } else if (state is HomeError) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: Text(state.exception.message)),
              ButtonWidget(
                  text: 'تلاش مجدد',
                  onPressed: () {
                    BlocProvider.of<HomeBloc>(context).add(HomeRefresh());
                  })
            ],
          );
        } else {
          throw Exception('State is not supported');
        }
      }),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({
    super.key,
    required this.title,
    required this.onTap,
  });

  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 18, right: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: themeData.textTheme.titleMedium,
          ),
          const Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'نمایش همه',
                  style: themeData.textTheme.labelMedium,
                ),
                const SizedBox(
                  width: 6,
                ),
                Center(
                  child: Icon(
                    CupertinoIcons.right_chevron,
                    color: themeData.colorScheme.primary,
                    size: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
