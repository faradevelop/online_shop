import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/data/model/product.dart';

class FavoriteItem extends StatelessWidget {
  const FavoriteItem({
    super.key,
    required this.icon,
    this.counter = false,
    required this.item,
    required this.onTap,
    this.onFavorite,
    this.loading = false,
  });

  final ProductEntity item;
  final IconData icon;
  final bool counter;
  final Function() onTap;
  final bool loading;
  final GestureTapCallback? onFavorite;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 18),
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
                        child: Image.network(item.image ?? ""),
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
                                      item.title ?? '',
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
                                          color: Colors.black.withOpacity(0.07),
                                          offset: const Offset(0, 1),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: onFavorite,
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
                                visible: item.price != item.realPrice,
                                child: Text(
                                  item.realPrice ?? "",
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        item.price ?? "",
                                        style: themeData.textTheme.titleMedium!
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
  }
}
