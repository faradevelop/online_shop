import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:online_shop/data/model/product.dart';

class ProductItemWidget extends StatelessWidget {
  const ProductItemWidget(
      {super.key, required this.onTap, required this.product});

  final ProductEntity product;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 118,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              width: 118,
              height: 130,
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
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    product.image ?? "",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Iconsax.add);
                    },
                  )),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6, right: 6),
              child: Row(
                children: [
                  Text(
                    product.price.toString(),
                    style: themeData.textTheme.labelSmall,
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                  Image.asset(
                    'assets/images/toman.png',
                    width: 14,
                  ),
                  const Spacer(),
                  Visibility(
                    visible: product.realPrice != product.price,
                    child: Text(
                      product.realPrice.toString(),
                      style: themeData.textTheme.labelSmall!.copyWith(
                          color: themeData.hintColor,
                          decoration: TextDecoration.lineThrough),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3, right: 4),
              child: Text(
                product.title ?? "",
                style: themeData.textTheme.titleSmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
