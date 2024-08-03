import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:online_shop/data/response/cart_details_response.dart';

class ProductHorizItem extends StatelessWidget {
  const ProductHorizItem({
    super.key,
    required this.icon,
    this.counter = false,
    required this.item,
    required this.onTap,
    this.onDelete,
    this.loading = false,
    this.onIncrease,
    this.onDecrease,
  });

  final CartItem item;
  final IconData icon;
  final bool counter;
  final Function() onTap;
  final bool loading;
  final GestureTapCallback? onDelete;
  final GestureTapCallback? onIncrease;
  final GestureTapCallback? onDecrease;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    if (item.product != null && item.count != null) {
      return Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18,top: 18 ),
            child: SizedBox(
              height: 140,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onTap,
                        child: Container(
                          width: 100,
                          height: 120,
                          decoration: BoxDecoration(
                            color: themeData.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                offset: const Offset(0, 1),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                          child: Image.network(item.product!.image ?? ""),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 0, 12, 0),
                          child: SizedBox(
                            height: 120,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.product!.title ?? '',
                                        maxLines: 2,
                                        style: themeData.textTheme.titleMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),const SizedBox(width: 6,),
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: themeData
                                            .colorScheme.primaryContainer,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.07),
                                            offset: const Offset(0, 1),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: onDelete,
                                          child: Icon(
                                            icon,
                                            color: counter
                                                ? themeData.primaryColor
                                                : Colors.red,
                                            size: 22,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Visibility(
                                  visible: item.product!.price!=item.product!.realPrice,
                                  child: Text(
                                    item.product!.realPrice ?? "",
                                    style: themeData.textTheme.titleSmall!
                                        .copyWith(
                                            color: themeData.hintColor,
                                            decoration:
                                                TextDecoration.lineThrough),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          item.product!.price ?? "",
                                          style: themeData
                                              .textTheme.titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 2,
                                        ),
                                        Image.asset(
                                          'assets/images/toman.png',
                                          width: 18,
                                        ),
                                      ],
                                    ),

                                    //  Spacer(),
                                    counter
                                        ? Container(
                                            width: 104,
                                            height: 32,
                                            decoration: BoxDecoration(
                                              color: themeData
                                                  .colorScheme.primaryContainer,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.07),
                                                  offset: const Offset(0, 1),
                                                  blurRadius: 3,
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              child: Row(
                                                /*  mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,*/
                                                children: [
                                                  GestureDetector(
                                                    onTap: onIncrease,
                                                    child: Icon(
                                                      Iconsax.add,
                                                      color: themeData
                                                          .primaryColor,
                                                      size: 22,
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    item.count.toString(),
                                                    style: themeData
                                                        .textTheme.labelMedium!
                                                        .copyWith(fontSize: 17),
                                                  ),
                                                  const Spacer(),
                                                  GestureDetector(
                                                    onTap: item.count! > 1
                                                        ? onDecrease
                                                        : () {},
                                                    child: Icon(
                                                      Iconsax.minus,
                                                      color:item.count! > 1
                                                          ? themeData
                                                          .primaryColor:Colors.grey.shade400,
                                                      size: 22,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    height: 0.8,
                    color: themeData.dividerColor,
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: loading,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: 158,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                    ),
                    child: const CupertinoActivityIndicator(),
                  ),
                ),
              ],
            ),
          )
        ],
      );
    } else {
      return Container();
    }
  }
}
