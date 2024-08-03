import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:online_shop/data/model/product.dart';
import 'package:online_shop/data/repository/cart_repository.dart';
import 'package:online_shop/data/repository/product_repository.dart';
import 'package:online_shop/ui/cart/bloc/cart_bloc.dart';
import 'package:online_shop/ui/product/bloc/product_bloc.dart';
import 'package:online_shop/ui/product/comments/comments.dart';
import 'package:online_shop/ui/product/favorites/bloc/favorite_bloc.dart';
import 'package:online_shop/ui/widgets/appbar_widget.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';
import 'package:online_shop/ui/widgets/loading_widget.dart';
import 'package:online_shop/ui/widgets/snack_bar_widget.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key, required this.productId});

  final int productId;

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) {
                  final productBloc =
                      ProductBloc(productRepository: productRepository);
                  productBloc.add(ProductStarted(productId: widget.productId));
                  return productBloc;
                },
              ),
              BlocProvider(
                create: (context) => CartBloc(cartRepository),
              ),
              BlocProvider(
                create: (context) {
                  final favoriteBloc = FavoriteBloc(productRepository);

                  return favoriteBloc;
                },
              ),
            ],
            child: BlocListener<CartBloc, CartState>(
              listener: (context, state) {
                // TODO: implement listener
                if (state is AddToCartButtonSuccess) {
                  final String msg = state.cart.message ?? "";
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: SnackBarContentWidget(
                            msg: msg, icn: CupertinoIcons.check_mark_circled)),
                  );
                } else if (state is AddToCartButtonError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    // SnackBar(content: Text("خطا : ${state.exception.message}")),
                    SnackBar(
                        content: SnackBarContentWidget(
                            msg: "خطا : ${state.exception.message}",
                            icn: CupertinoIcons.exclamationmark_circle)),
                  );
                }
              },
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductSuccess) {
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 70,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height / 2.5,
                                child: Stack(
                                  children: [
                                    /*ProductSliderWidget(
                                      images: [state.product.image ?? ""],
                                    ),*/
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          18, 8, 18, 8),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                2.5,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          child: Image.network(
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(Iconsax.add),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2,
                                            state.product.image ?? "",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 26, top: 20),
                                        child: _FavoriteWidget(
                                          favorite:
                                              state.product.bookmarked ?? false,
                                          onTap: () {
                                            BlocProvider.of<FavoriteBloc>(
                                                    context)
                                                .add(
                                                    UpdateFavoriteButtonClicked(
                                                        state.product.id!,
                                                        false));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 18,
                                  ),
                                  Text(
                                    "دسته بندی : ${state.product.category}  ",
                                    style: TextStyle(
                                        color: themeData.primaryColor),
                                  ),
                                  const Spacer(),
                                  Visibility(
                                    visible: state.product.discountPercent != 0,
                                    child: Text(
                                      state.product.realPrice.toString(),
                                      style: themeData.textTheme.labelSmall!
                                          .copyWith(
                                              color: themeData.hintColor,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontSize: 16),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Visibility(
                                    visible: state.product.discountPercent != 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 1),
                                      decoration: BoxDecoration(
                                          color: const Color(0xFFFF3D3D),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Text(
                                        "${state.product.discountPercent.toString()} %",
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 18,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 18,
                                  ),
                                  Expanded(
                                    child: Text(
                                      state.product.title ?? "",
                                      style: themeData.textTheme.titleLarge,
                                      maxLines: 2,
                                    ),
                                  ),
                                  Text(
                                    state.product.price.toString(),
                                    style: themeData.textTheme.labelSmall!
                                        .copyWith(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Image.asset(
                                    'assets/images/toman.png',
                                    width: 20,
                                  ),
                                  const SizedBox(
                                    width: 18,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: Text(
                                  state.product.description ?? "",
                                  style:
                                      themeData.textTheme.bodySmall!.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 18),
                                child: MaterialButton(
                                  minWidth: double.infinity,
                                  height: 48,
                                  color: themeData.colorScheme.secondary,
                                  elevation: 0,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => Comments(
                                                productId: state.product.id!,
                                              )),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                          color: themeData.dividerColor,
                                          width: 1)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Iconsax.message_text_1,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "نظرات",
                                        style: themeData.textTheme.titleMedium!
                                            .copyWith(fontSize: 18),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "${state.product.reviewsCount} نظر",
                                        style: themeData.textTheme.bodySmall!
                                            .copyWith(fontSize: 18),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      const Icon(
                                        CupertinoIcons.chevron_left,
                                        size: 16,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 120,
                              ),
                            ],
                          ),
                        ),
                        CartCountButton(
                          product: state.product,
                        ),
                        AppbarWidget(
                          title: '',
                          backButton: true,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is ProductError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: Text(state.exception.message)),
                        ButtonWidget(
                            text: 'تلاش مجدد',
                            onPressed: () {
                              BlocProvider.of<ProductBloc>(context).add(
                                  ProductStarted(productId: widget.productId));
                            })
                      ],
                    );
                  } else {
                    return const SizedBox.shrink();
                    // throw Exception('State is not supported');
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoriteWidget extends StatefulWidget {
  const _FavoriteWidget({
    super.key,
    required this.favorite,
    required this.onTap,
  });

  final bool favorite;
  final GestureTapCallback onTap;

  @override
  State<_FavoriteWidget> createState() => _FavoriteWidgetState();
}

class _FavoriteWidgetState extends State<_FavoriteWidget> {
  late bool isFavorite;
  late StreamSubscription<FavoriteState> _subscription;

  @override
  void initState() {
    isFavorite = widget.favorite;
    _subscription = context.read<FavoriteBloc>().stream.listen(
      (state) {
        if (state is UpdateFavoriteButtonSuccess) {
          final String msg = state.favorited
              ? "محصول به علاقه مندی ها اضافه شد"
              : "محصول از علاقه مندی ها حذف شد";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: SnackBarContentWidget(
                    msg: msg, icn: CupertinoIcons.check_mark_circled)),
          );
          isFavorite = !isFavorite;
        } else if (state is UpdateFavoriteButtonError) {
          ScaffoldMessenger.of(context).showSnackBar(
            // SnackBar(content: Text("خطا : ${state.exception.message}")),
            const SnackBar(
                content: SnackBarContentWidget(
                    msg: "خطا ", icn: CupertinoIcons.exclamationmark_circle)),
          );
        }
        setState(() {});
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Icon(
        isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
        color: Colors.red,
        size: 30,
      ),
    );
  }
}

class CartCountButton extends StatefulWidget {
  const CartCountButton({
    super.key,
    required this.product,
  });

  final ProductEntity product;

  @override
  State<CartCountButton> createState() => _CartCountButtonState();
}

class _CartCountButtonState extends State<CartCountButton> {
  late StreamSubscription<CartState> _subscription;
  late int _cartCount;
  late bool _loading = false;

  @override
  void initState() {
    super.initState();
    _cartCount = widget.product.cartCount ?? 0;
    _subscription = context.read<CartBloc>().stream.listen((state) {
      if (state is AddToCartButtonSuccess) {
        _cartCount = state.cart.count ?? 0;
        _loading = false;
      } else if (state is AddToCartButtonLoading) {
        _loading = true;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.09),
                      offset: const Offset(0, -3),
                      blurRadius: 6)
                ]),
            child: _cartCount == 0
                ? ButtonWidget(
                    text: "افزودن به سبد خرید",
                    onPressed: () {
                      context.read<CartBloc>().add(
                          ProductAddButtonClicked(widget.product.id!, true));
                    },
                    loading: _loading,
                  )
                : Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                            onTap: () {
                              context.read<CartBloc>().add(
                                  ProductAddButtonClicked(
                                      widget.product.id!, true));
                            },
                            child: const Icon(
                              Iconsax.add,
                              color: Colors.white,
                            )),
                        const Spacer(),
                        Text(
                          _cartCount.toString(),
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              context.read<CartBloc>().add(
                                  ProductAddButtonClicked(
                                      widget.product.id!, false));
                            },
                            child: Icon(
                              _cartCount == 1 ? Iconsax.trash : Iconsax.minus,
                              color: Colors.white,
                            )),
                        const SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
