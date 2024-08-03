import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:online_shop/data/model/category.dart';

class CategoryItemWidget extends StatelessWidget {
  const CategoryItemWidget({
    super.key,
    required this.onTap, required this.category,
  });

  final CategoryEntity category;

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 105,
        height: 105,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              width: 105,
              height: 105,
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

                    fit: BoxFit.fill,
                    category.image ?? "",
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Iconsax.add);
                    },

                  )),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 3, right: 4),
              child: Text(
                category.title??"دسته بندی",
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
