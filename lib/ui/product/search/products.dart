import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:online_shop/data/model/category.dart';
import 'package:online_shop/data/model/product.dart';
import 'package:online_shop/data/repository/product_repository.dart';
import 'package:online_shop/ui/product/product_detail.dart';
import 'package:online_shop/ui/product/search/bloc/search_bloc.dart';
import 'package:online_shop/ui/widgets/appbar_widget.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';
import 'package:online_shop/ui/widgets/empty_view.dart';
import 'package:online_shop/ui/widgets/loading_widget.dart';
import 'package:online_shop/ui/widgets/product_item_widget.dart';

class Products extends StatefulWidget {
  const Products({super.key, this.category, required this.defaultSortId});

  final CategoryEntity? category;
  final int defaultSortId;

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  late CategoryEntity? _selectedCategory = widget.category;
  late int _selectedSortId;

  String? _searchTerm;
  SearchBloc? searchBloc;

  @override
  void initState() {
    _selectedSortId = widget.defaultSortId;
    super.initState();
  }

  @override
  void dispose() {
    searchBloc?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: BlocProvider(
        create: (context) {
          final bloc = SearchBloc(productRepository);
          searchBloc = bloc;
          bloc.add(ProductListStarted(
              category: widget.category, sort: sortMap[_selectedSortId]));
          return bloc;
        },
        child: BlocBuilder<SearchBloc, SearchState>(
          builder: (context, state) {
            if (state is ProductListSuccess) {
              return SafeArea(
                child: Column(
                  children: [
                    AppbarWidget(
                      title: _selectedCategory != null
                          ? _selectedCategory!.title
                          : 'همه محصولات',
                      backButton: true,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _FilterProducts(
                      sortId: _selectedSortId,
                      onTap: (sort) {
                        _selectedSortId = sort.id;

                        BlocProvider.of<SearchBloc>(context).add(
                          SearchListStarted(
                              category: _selectedCategory,
                              sort: sortMap[_selectedSortId],
                              searchTerm: _searchTerm),
                        );
                      },
                      onSearch: (term) {
                        _searchTerm = term;
                        BlocProvider.of<SearchBloc>(context).add(
                          SearchListStarted(
                            category: _selectedCategory,
                            sort: sortMap[_selectedSortId],
                            searchTerm: _searchTerm,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 36,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.categories.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: index == 0 ? 0 : 8),
                            child: _CategoryListItem(
                              category: state.categories[index],
                              isSelected: _selectedCategory?.id ==
                                  state.categories[index].id,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = state.categories[index];

                                  BlocProvider.of<SearchBloc>(context)
                                      .add(SearchListStarted(
                                    category: _selectedCategory,
                                    sort: sortMap[_selectedSortId],
                                  ));
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                        child: state.isLoadingList
                            ? const LoadingWidget()
                            : ProductsGrid(
                                products: state.products,
                              )),
                  ],
                ),
              );
            } else if (state is ProductListLoading) {
              return const LoadingWidget();
            } else if (state is ProductListError) {
              return EmptyView(
                  message: "خطای نامشخص",
                  callToAction: ButtonWidget(
                      text: 'تلاش مجدد',
                      onPressed: () {
                        BlocProvider.of<SearchBloc>(context)
                            .add(ProductListStarted(category: widget.category));
                      }));
            } else {
              throw Exception('State is not supported');
            }
          },
        ),
      ),
    );
  }
}

class ProductsGrid extends StatefulWidget {
  const ProductsGrid({
    super.key,
    required this.products,
  });

  final List<ProductEntity> products;

  @override
  State<ProductsGrid> createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  late StreamSubscription<SearchState> _searchStream;
  late bool _loading = false;
  late List<ProductEntity> productList;

  @override
  void initState() {
    super.initState();
    productList = widget.products;
    _searchStream = context.read<SearchBloc>().stream.listen((state) {
      if (state is ProductListSuccess) {
        productList = state.products;
        _loading = false;
      } else if (state is ProductListLoading) {
        _loading = true;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const LoadingWidget()
        : (productList.isNotEmpty
            ? GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.57,
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 16,
                ),
                itemCount: productList.length + 4,
                itemBuilder: (context, index) {
                  return index < productList.length
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ProductItemWidget(
                              product: productList[index],
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetail(
                                      productId: productList[index].id!,
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Container();
                },
              )
            : const EmptyView(message: "محصولی یافت نشد"));
  }
}

class _CategoryListItem extends StatelessWidget {
  const _CategoryListItem({
    super.key,
    this.isSelected = false,
    required this.onTap,
    required this.category,
  });

  final CategoryEntity category;
  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        // width: 75,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? themeData.primaryColor : null,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: themeData.primaryColor,
            width: 1.3,
          ),
        ),
        child: Center(
          child: Text(
            category.title ?? "",
            style: TextStyle(
              color: isSelected
                  ? themeData.colorScheme.secondary
                  : themeData.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterProducts extends StatefulWidget {
  const _FilterProducts({
    super.key,
    required this.sortId,
    required this.onTap,
    required this.onSearch,
  });

  final int sortId;
  final Function(Sort sort) onTap;

  final Function(String search) onSearch;

  @override
  State<_FilterProducts> createState() => _FilterProductsState();
}

class _FilterProductsState extends State<_FilterProducts> {
  late int _selectedItemId = widget.sortId;
  final TextEditingController searchTermController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 47,
              decoration: BoxDecoration(
                color: themeData.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    offset: const Offset(0, 1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: TextField(
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    widget.onSearch(value);

                  },
                  controller: searchTermController,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 14),
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Iconsax.search_normal,
                        color: themeData.iconTheme.color,
                      ),
                      hintText: "جستحوی محصول"),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
            height: 47,
            width: 47,
            decoration: BoxDecoration(
              color: themeData.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(9),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  offset: const Offset(0, 1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: PopupMenuButton<Sort>(
              position: PopupMenuPosition.under,
              surfaceTintColor: themeData.scaffoldBackgroundColor,
              onSelected: (value) {
                setState(() {
                  _selectedItemId = value.id;
                });
                widget.onTap(value);
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: Sort(
                        id: 1,
                        orderBy: "id",
                        orderType: "DESC",
                        txt: "جدیدترین"),
                    height: 8,
                    child: _PopupItemWidget(
                      isSelected: _selectedItemId == 1,
                      text: "جدیدترین",
                    ),
                  ),
                  PopupMenuItem(
                    value: Sort(
                        id: 2,
                        orderBy: "discount",
                        orderType: "DESC",
                        txt: "بیشترین تخفیف"),
                    height: 8,
                    child: _PopupItemWidget(
                      isSelected: _selectedItemId == 2,
                      text: "بیشترین تخفیف",
                    ),
                  ),
                  PopupMenuItem(
                    value: Sort(
                        id: 3,
                        orderBy: "price",
                        orderType: "DESC",
                        txt: "گران ترین"),
                    height: 8,
                    child: _PopupItemWidget(
                      isSelected: _selectedItemId == 3,
                      text: "گران ترین",
                    ),
                  ),
                  PopupMenuItem(
                    value: Sort(
                        id: 4,
                        orderBy: "price",
                        orderType: "ASC",
                        txt: "ارزان ترین"),
                    height: 8,
                    child: _PopupItemWidget(
                      isSelected: _selectedItemId == 4,
                      text: "ارزان ترین",
                      border: false,
                    ),
                  ),
                ];
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Iconsax.sort,
                // color: themeData.primaryColor,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopupItemWidget extends StatelessWidget {
  const _PopupItemWidget({
    super.key,
    required this.text,
    this.border = true,
    this.isSelected = false,
  });

  final bool isSelected;
  final String text;
  final bool border;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            // color: themeData.primaryColorLight,
            border: border
                ? Border(
                    bottom: BorderSide(color: themeData.dividerColor),
                  )
                : null),
        child: Center(
          child: Text(
            text,
            style: themeData.textTheme.titleLarge!.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? themeData.primaryColor
                  : themeData.textTheme.titleLarge!.color,
            ),
          ),
        ),
      ),
    );
  }
}

Map<int, Sort> sortMap = {
  1: Sort(id: 1, orderBy: "id", orderType: "DESC", txt: "جدیدترین"),
  2: Sort(id: 2, orderBy: "discount", orderType: "DESC", txt: "بیشترین تخفیف"),
  3: Sort(id: 3, orderBy: "price", orderType: "DESC", txt: "گران ترین"),
  4: Sort(id: 4, orderBy: "price", orderType: "ASC", txt: "ارزان ترین"),
  5: Sort(id: 1, orderBy: "id", orderType: "ASC", txt: "قدیمی ترین"),
};
