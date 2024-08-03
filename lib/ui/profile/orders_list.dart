import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_shop/data/model/order.dart';
import 'package:online_shop/data/model/product.dart';
import 'package:online_shop/data/repository/order_repository.dart';
import 'package:online_shop/data/repository/profile_repository.dart';
import 'package:online_shop/ui/order/bloc/order_bloc.dart';
import 'package:online_shop/ui/widgets/appbar_widget.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';
import 'package:online_shop/ui/widgets/empty_view.dart';
import 'package:online_shop/ui/widgets/loading_widget.dart';

class OrdersList extends StatelessWidget {
  const OrdersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          final bloc = OrderBloc(orderRepository, profileRepository);
          bloc.add(OrderListStarted());
          return bloc;
        },
        child: SafeArea(
          child: Stack(
            children: [
              BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoading) {
                    return const LoadingWidget();
                  } else if (state is OrderListSuccess) {
                    return Column(
                      children: [
                        AppbarWidget(
                          title: 'سفارش ها',
                          backButton: true,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        state.orders.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 0, 18, 60),
                                  itemCount: state.orders.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 14),
                                      child: OrderItem(
                                        order: state.orders[index],
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const EmptyView(
                                message: "تاکنون سفارشی ثبت نکرده اید",
                              ),
                      ],
                    );
                  } else if (state is OrderListError) {
                    return EmptyView(
                      message: "خطای نامشخص",
                      callToAction: ButtonWidget(
                        text: "بازگشب به سبد خرید",
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    );
                  } else {
                    throw Exception('State not supported EEEEEEEEEEEEEEEEEEE');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  const OrderItem({
    super.key,
    required this.order,
  });

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: themeData.dividerColor),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.02),
                offset: const Offset(0, 1),
                blurRadius: 14)
          ]),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Text("آدرس :", style: themeData.textTheme.bodySmall),
                const SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    order.address ?? "",
                    style: themeData.textTheme.titleMedium,
                  ),
                ),
                Text(
                  "شماره سفارش: ",
                  style: themeData.textTheme.bodySmall,
                ),
                Text(
                  order.trackingCode.toString(),
                  style: themeData.textTheme.titleMedium,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          OrderItemsList(
            items: order.products!,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Text(
                  "تعداد : ",
                  style: themeData.textTheme.bodySmall,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  order.products!.length.toString(),
                  style: themeData.textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  "قیمت سفارش :",
                  style: themeData.textTheme.bodySmall,
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  order.totalPrice.toString(),
                  style: themeData.textTheme.titleMedium,
                ),
                const SizedBox(
                  width: 2,
                ),
                Image.asset(
                  'assets/images/toman.png',
                  width: 18,
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                  decoration: BoxDecoration(
                      color: getStatusColor(order.status!).bgColor,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    order.status!,
                    style: TextStyle(
                        fontSize: 13,
                        color: getStatusColor(order.status!).textColor),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OrderItemsList extends StatelessWidget {
  const OrderItemsList({
    super.key,
    required this.items,
  });

  final List<ProductEntity> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.topLeft,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: index != 0
                      ? Border(
                          right: BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: 1.5),
                        )
                      : null,
                ),
                child: Center(
                  child: Image.network(items[index].image!, height: 40),
                ),
              ),
              Visibility(
                visible: items[index].cartCount != null,
                child: Container(
                  height: 17,
                  width: 17,
                  margin: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                      color: const Color(0xFFCBE0FF),
                      borderRadius: BorderRadius.circular(100)),
                  child: Center(
                      child: Text(
                    items[index].cartCount.toString(),
                    style: const TextStyle(fontSize: 11, color: Colors.black),
                  )),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class OrderStatus {
  Color bgColor;
  Color textColor;

  OrderStatus(this.bgColor, this.textColor);
}

OrderStatus getStatusColor(String status) {
  if (status == "تحویل داده شده" || status == "پرداخت شده") {
    return OrderStatus(Colors.lightGreen, Colors.white);
  } else if (status == "در حال آماده سازی") {
    return OrderStatus(Colors.lightBlue, Colors.white);
  } else if (status == "لغو شده") {
    return OrderStatus(Colors.red, Colors.white);
  } else if (status == "در حال پرداخت") {
    return OrderStatus(const Color(0xFFED723F), Colors.white);
  }
  return OrderStatus(Colors.lightGreen, Colors.white);
}
