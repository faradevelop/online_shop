import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:online_shop/data/repository/auth_repository.dart';
import 'package:online_shop/data/repository/cart_repository.dart';
import 'package:online_shop/data/response/cart_details_response.dart';
import 'package:online_shop/ui/auth/auth.dart';
import 'package:online_shop/ui/cart/bloc/cart_bloc.dart';
import 'package:online_shop/ui/order/order.dart';
import 'package:online_shop/ui/product/product_detail.dart';
import 'package:online_shop/ui/product/search/products.dart';
import 'package:online_shop/ui/widgets/appbar_widget.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';
import 'package:online_shop/ui/widgets/empty_view.dart';
import 'package:online_shop/ui/widgets/loading_widget.dart';
import 'package:online_shop/ui/widgets/product_horiz_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  CartBloc? cartBloc;
  final RefreshController _refreshController = RefreshController();
  StreamSubscription? stateStreamSubscription;

  @override
  void initState() {
    AuthRepository.authChangeNotifier.addListener(authChangeNotifierListener);
    super.initState();
  }

  //when authChangeNotifier change this function will be call:
  void authChangeNotifierListener() {
    /* BlocProvider.of<CartBloc>(context)
        .add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));*/
    cartBloc?.add(CartAuthInfoChanged(AuthRepository.authChangeNotifier.value));
  }

  @override
  void dispose() {
    AuthRepository.authChangeNotifier
        .removeListener(authChangeNotifierListener);
    cartBloc?.close();
    stateStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
      create: (context) {
        final bloc = CartBloc(cartRepository);
        cartBloc = bloc;
        stateStreamSubscription = bloc.stream.listen(
          (state) {
            if (_refreshController.isRefresh) {
              if (state is CartSuccess) {
                _refreshController.refreshCompleted();
              }
            }
          },
        );
        bloc.add(CartStarted(AuthRepository.authChangeNotifier.value));
        return bloc;
      },
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const LoadingWidget();
          } else if (state is CartError) {
            return Center(
              child: Text(state.exception.message),
            );
          } else if (state is CartSuccess) {
            return Column(
              children: [
                AppbarWidget(
                  title: 'سبد خرید',
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
                state.cartDetails.items != null
                    ? Expanded(
                        child: SmartRefresher(
                          controller: _refreshController,
                          header: const ClassicHeader(
                            completeText: 'سبد خرید بروزرسانی شد',
                            refreshingText: '',
                            idleText: '',
                            releaseText: '',
                            idleIcon: null,
                            spacing: 2,
                            refreshingIcon: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                  strokeWidth: 2,
                                )),
                          ),
                          onRefresh: () {
                            cartBloc?.add(CartStarted(
                                AuthRepository.authChangeNotifier.value,
                                isRefresh: true));
                          },
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.cartDetails.items!.length,
                            itemBuilder: (context, index) {
                              return ProductHorizItem(
                                item: state.cartDetails.items![index],
                                icon: Iconsax.trash,
                                counter: true,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetail(
                                          productId: state.cartDetails
                                              .items![index].product!.id!),
                                    ),
                                  );
                                },
                                loading: state.cartDetails.items![index] ==
                                    state.loadingItem,
                                onDelete: () {
                                  cartBloc?.add(CartDeleteButtonClicked(state
                                      .cartDetails.items![index].product!.id!));
                                },
                                onIncrease: () {
                                  cartBloc?.add(ChangeCartItemCount(
                                      state.cartDetails.items![index].product!
                                          .id!,
                                      true));
                                },
                                onDecrease: () {
                                  cartBloc?.add(ChangeCartItemCount(
                                      state.cartDetails.items![index].product!
                                          .id!,
                                      false));
                                },
                              );
                            },
                          ),
                        ),
                      )
                    : Container(),
                PriceSection(
                  data: state.cartDetails,
                ),
                const SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: ButtonWidget(
                      text: 'ثبت سفارش',
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Order(
                            cartDetails: state.cartDetails,
                          ),
                        ));
                      }),
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            );
          } else if (state is CartAuthRequired) {
            return Padding(
              padding: const EdgeInsets.all(22),
              child: EmptyView(
                message: "لطفا وارد حساب کاربری خود شوید",
                image: SvgPicture.asset(
                  "assets/images/auth_required.svg",
                  width: 200,
                ),
                callToAction: ButtonWidget(
                  text: 'ورود',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Auth(
                          loginMode: true,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (state is CartEmpty) {
            return Column(
              children: [
                AppbarWidget(
                  title: 'سبد خرید',
                  onTap: () {},
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: EmptyView(
                    message: "محصولی در سبد خرید شما وجود ندارد",
                    image: SvgPicture.asset(
                      "assets/images/empty_cart.svg",
                      width: 200,
                    ),
                    callToAction: ButtonWidget(
                      text: 'بروز رسانی سبد خرید',
                      onPressed: () {
                        cartBloc?.add(CartStarted(
                            AuthRepository.authChangeNotifier.value));
                      },
                    ),
                  ),
                ),
                const Spacer()
              ],
            );
          } else {
            throw Exception('State not supported EEEEEEEEEEEEEEEEEEE');
          }
        },
      ),
    );
  }
}

class PriceSection extends StatefulWidget {
  const PriceSection({
    super.key,
    required this.data,
  });

  final CartDetailsResponse data;

  @override
  State<PriceSection> createState() => _PriceSectionState();
}

class _PriceSectionState extends State<PriceSection> {
  late CartDetailsResponse _priceData;
  late StreamSubscription<CartState> _subscription;

  @override
  void initState() {
    super.initState();
    _priceData = widget.data;
    _subscription = context.read<CartBloc>().stream.listen((state) {
      if (state is CartSuccess) {
        if (state.isRefresh) {
          _priceData = state.cartDetails;
        } else if (state.loadingItem == null) {
          _priceData = state.cartDetails;
        }
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
    final ThemeData themeData = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
          color: themeData.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: themeData.dividerColor)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Row(
              children: [
                Text(
                  'مبلغ :',
                  style: themeData.textTheme.bodyMedium,
                ),
                const Spacer(),
                Text(
                  _priceData.price ?? "",
                  style: themeData.textTheme.titleLarge,
                ),
                const SizedBox(
                  width: 2,
                ),
                Image.asset(
                  'assets/images/toman.png',
                  width: 22,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: Row(
              children: [
                Text(
                  'مبلغ تخفیف :',
                  style: themeData.textTheme.bodyMedium,
                ),
                const Spacer(),
                Text(
                  _priceData.discountPrice ?? "",
                  style: themeData.textTheme.titleLarge!
                      .copyWith(color: Colors.red),
                ),
                const SizedBox(
                  width: 2,
                ),
                _priceData.discountPrice != "0"
                    ? Image.asset(
                        'assets/images/toman.png',
                        width: 22,
                      )
                    : Container(
                        width: 22,
                      ),
              ],
            ),
          ),
          Divider(
            color: themeData.dividerColor,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            child: Row(
              children: [
                Text(
                  'مبلغ کل :',
                  style: themeData.textTheme.bodyMedium,
                ),
                const Spacer(),
                Text(
                  _priceData.totalPrice ?? "",
                  style: themeData.textTheme.titleLarge,
                ),
                const SizedBox(
                  width: 2,
                ),
                Image.asset(
                  'assets/images/toman.png',
                  width: 22,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
