import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:online_shop/data/repository/cart_repository.dart';
import 'package:online_shop/ui/widgets/badge_widget.dart';

class AppbarWidget extends StatelessWidget {
  const AppbarWidget({
    super.key,
    this.title,
    this.logo = false,
    this.backButton = false,
    required this.onTap,
  });

  final bool logo;
  final bool backButton;
  final String? title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      height: 60,
      /* decoration: backButton
          ? BoxDecoration(
              color: themeData.colorScheme.secondary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 1),
                  blurRadius: 6,
                ),
              ],
            )
          : null,*/
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: themeData.dividerColor),
                  ),
                  child:  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Center(
                        child: Icon(
                          Iconsax.bag_2,
                          size: 24,
                        ),
                      ),
                      Positioned(
                        right: -6,
                        top: -6,
                        child: ValueListenableBuilder<int>(
                          valueListenable: CartRepository.cartItemCountNotifier,
                          builder: (context, value, child) {
                            return BadgeWidget(
                              value: value,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: themeData.dividerColor),
                    ),
                    child: Center(
                      child: Icon(
                        backButton ? Iconsax.arrow_left : Iconsax.search_normal,
                        size: 23,
                        // size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: logo
                ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Image.asset(
                      'assets/images/logo_horiz.png',
                      width: 140,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      title!,
                      style: themeData.textTheme.titleLarge,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
