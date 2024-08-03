import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop/data/model/address.dart';
import 'package:online_shop/data/repository/order_repository.dart';
import 'package:online_shop/data/repository/profile_repository.dart';
import 'package:online_shop/data/response/cart_details_response.dart';
import 'package:online_shop/ui/order/bloc/order_bloc.dart';
import 'package:online_shop/ui/order/payment_webview.dart';
import 'package:online_shop/ui/profile/address/address_detail.dart';
import 'package:online_shop/ui/widgets/address_widget.dart';
import 'package:online_shop/ui/widgets/appbar_widget.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';
import 'package:online_shop/ui/widgets/empty_view.dart';
import 'package:online_shop/ui/widgets/loading_widget.dart';
import 'package:online_shop/ui/widgets/snack_bar_widget.dart';

ValueNotifier<int> shippingChangeNotifier = ValueNotifier(_shipping);

int? _addressId;
 bool _loading = false;
 int _shipping = 1;

class Order extends StatelessWidget {
  const Order({super.key, required this.cartDetails});

  final CartDetailsResponse cartDetails;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      body: BlocProvider<OrderBloc>(
        create: (context) {
          final bloc = OrderBloc(orderRepository, profileRepository);
          bloc.add(OrderStarted());
          /*bloc.stream.listen((state) {
            if (state is OrderCreateLoading) {
              _loading = true;
            } else if (state is OrderCreateError) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: SnackBarContentWidget(
                        msg: "خطا در اتصال به درگاه پرداخت",
                        icn: CupertinoIcons.exclamationmark_circle)),
              );
              _loading = false;
            }
          });*/
          return bloc;
        },
        child: SafeArea(
          child: BlocBuilder<OrderBloc, OrderState>(builder: (context, state) {
            if (state is OrderLoading) {
              return const LoadingWidget();
            } else if (state is OrderSuccess) {
              _addressId = null;

              return Column(
                children: [
                  AppbarWidget(
                    title: 'تکمیل سفارش',
                    backButton: true,
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 18, bottom: 10),
                            child: Text(
                              'آدرس خود را انتخاب کنید',
                              style: themeData.textTheme.titleMedium,
                            ),
                          ),
                          ValueListenableBuilder<List<AddressEntity>>(
                            valueListenable:
                                ProfileRepository.addressListNotifier,
                            builder: (BuildContext context,
                                List<AddressEntity> value, Widget? child) {
                            return  AddressList(
                                address: value,
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
                            child: ButtonWidget(
                              isSecondary: true,
                              text: 'افزودن آدرس',
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddressDetail(
                                    provinces: state.provinces,
                                  ),
                                ));
                              },
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 18, bottom: 10),
                            child: Text(
                              'شیوه ارسال را انتخاب کنید',
                              style: themeData.textTheme.titleMedium,
                            ),
                          ),
                          const ShippingType(),
                          const SizedBox(
                            height: 20,
                          ),
                          _PriceSection(data: cartDetails),
                          const SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 30),
                            child: ButtonWidget(
                              loading: _loading,
                              text: 'پرداخت آنلاین',
                              onPressed: () {
                                if (_addressId == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: SnackBarContentWidget(
                                            msg: 'آدرس ارسال را انتخاب کنید',
                                            icn: CupertinoIcons
                                                .exclamationmark_circle)),
                                  );
                                  _loading = false;
                                } else {
                                  BlocProvider.of<OrderBloc>(context)
                                      .add(OrderCreate(_addressId!, _shipping));
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is OrderError) {
              return EmptyView(
                message: "خطای نامشخص",
                callToAction: ButtonWidget(
                  text: "بازگشب به سبد خرید",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            } else if (state is OrderCreateSuccess) {
              /* Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => PaymentWebView(link: state.link),
              )); */

              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentWebView(link: state.link),
                    ));
              });

              return const SizedBox.shrink();
            } else if (state is OrderCreateError) {
              return EmptyView(
                message: "خطا در اتصال به درگاه پرداخت",
                callToAction: ButtonWidget(
                  text: "بازگشب به سبد خرید",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            } else if (state is OrderCreateLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoadingWidget(),
                  const SizedBox(height: 30),
                  Text(
                    "در حال انتقال به درگاه پرداخت",
                    style: themeData.textTheme.bodyMedium!
                        .copyWith(color: themeData.colorScheme.onSecondary),
                  )
                ],
              );
            } else {
              throw Exception('State not supported EEEEEEEEEEEEEEEEEEE');
            }
          }),
        ),
      ),
    );
  }
}

class AddressList extends StatefulWidget {
  const AddressList({
    super.key,
    required this.address,
  });

  final List<AddressEntity> address;

  @override
  State<AddressList> createState() => _AddressListState();
}

class _AddressListState extends State<AddressList> {
  int? selectedAddressIndex;

  @override
  Widget build(BuildContext context) {
   // final ThemeData themeData = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.address.length,
          (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AddressWidget(
                selectable: true,
                isSelected: index == selectedAddressIndex,
                onTap: () {
                  setState(() {
                    selectedAddressIndex = index;
                    _addressId = widget.address[index].id!;
                  });
                },
                item: widget.address[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PriceSection extends StatelessWidget {
  const _PriceSection({
    super.key,
    required this.data,
  });

  final CartDetailsResponse data;

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
                  'هزینه ارسال :',
                  style: themeData.textTheme.bodyMedium,
                ),
                const Spacer(),
                ValueListenableBuilder<int>(
                  valueListenable: shippingChangeNotifier,
                  builder: (BuildContext context, int value, Widget? child) {
                    return Text(
                      _shipping == 1 ? "20,000" : "10,000",
                      style: themeData.textTheme.titleLarge,
                    );
                  },
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
                  'مبلغ :',
                  style: themeData.textTheme.bodyMedium,
                ),
                const Spacer(),
                Text(
                  data.price ?? "",
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
                  data.discountPrice ?? "",
                  style: themeData.textTheme.titleLarge!
                      .copyWith(color: Colors.red),
                ),
                const SizedBox(
                  width: 2,
                ),
                data.discountPrice != "0"
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
                ValueListenableBuilder<int>(
                  valueListenable: shippingChangeNotifier,
                  builder: (BuildContext context, int value, Widget? child) {
                    int total = int.parse(data.totalPrice!.replaceAll(",", ""));
                    int price;
                    if (_shipping == 1) {
                      price = total + 20000;
                    } else {
                      price = total + 10000;
                    }

                    return Text(
                      price.toString(),
                      style: themeData.textTheme.titleLarge,
                    );
                  },
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

class ShippingMethod {
  String title;
  String price;
  bool isSelected;
  int value;

  ShippingMethod({
    required this.title,
    required this.price,
    this.isSelected = false,
    required this.value,
  });
}

List<ShippingMethod> methods = [
  ShippingMethod(
    title: "پست پیشتاز (ارسال سریع)",
    price: "20,000",
    value: 1,
    isSelected: true,
  ),
  ShippingMethod(
    title: "تیپاکس",
    price: "10,000",
    value: 2,
  ),
];

class ShippingType extends StatefulWidget {
  const ShippingType({
    super.key,
  });

  @override
  State<ShippingType> createState() => _ShippingTypeState();
}

class _ShippingTypeState extends State<ShippingType> {
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
        children: List.generate(methods.length, (index) {
          var method = methods[index];
          return GestureDetector(
            onTap: () {
              /* methods.forEach((element) {
                element.isSelected = false;
              });*/
              for (var element in methods) {
                element.isSelected = false;
              }
              methods[index].isSelected = true;
              //Get.find<OrderController>().selectMethod(method);
              setState(() {
                _shipping = methods[index].value;
                shippingChangeNotifier.value = _shipping;

              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  Text(
                    method.title,
                    style: themeData.textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  Text(method.price, style: themeData.textTheme.titleLarge),
                  const SizedBox(
                    width: 2,
                  ),
                  Image.asset(
                    'assets/images/toman.png',
                    width: 22,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: Theme.of(context).hintColor)),
                    child: Visibility(
                      visible: method.isSelected,
                      child: Center(
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
