import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:online_shop/data/repository/cart_repository.dart';
import 'package:online_shop/ui/cart/cart.dart';
import 'package:online_shop/ui/product/categories.dart';
import 'package:online_shop/ui/product/favorites/favorites.dart';
import 'package:online_shop/ui/home/home.dart';
import 'package:online_shop/ui/profile/profile.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

const int categoriesIndex = 1;
const int cartIndex = 2;
const int homeIndex = 0;
const int favoriteIndex = 3;
const int profileIndex = 4;





class _RootState extends State<Root> {
  static int selectedScreenIndex = homeIndex;

  @override
  void initState() {
    cartRepository.getCart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 70,
              child: IndexedStack(
                index: selectedScreenIndex,
                children: const [
                  Home(),
                  Categories(),
                  Cart(),
                  Favorites(),
                  Profile(),
                ],
              ),
            ),
            _BottomNavigation(
              selectedIndex: selectedScreenIndex,
              onTap: (int index) {
                setState(() {
                  selectedScreenIndex = index;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    super.key,
    required this.onTap,
    required this.selectedIndex,
  });

  final Function(int index) onTap;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        width: double.infinity,
        height: 103,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                height: 70,
                decoration: BoxDecoration(
                  color: themeData.colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, -3),
                        blurRadius: 6),
                  ],
                ),
                child: Row(
                  children: [
                    _BottomNavigationItem(
                      icon: Iconsax.element_3,
                      isActive: selectedIndex == categoriesIndex,
                      onTap: () {
                        onTap(categoriesIndex);
                      },
                    ),
                    _BottomNavigationItem(
                      icon: Iconsax.shopping_cart,
                      isActive: selectedIndex == cartIndex,
                      onTap: () {
                        onTap(cartIndex);
                      },
                    ),
                    Expanded(child: Container()),
                    _BottomNavigationItem(
                      icon: Iconsax.heart,
                      isActive: selectedIndex == favoriteIndex,
                      onTap: () {
                        onTap(favoriteIndex);
                      },
                    ),
                    _BottomNavigationItem(
                      icon: Iconsax.user,
                      isActive: selectedIndex == profileIndex,
                      onTap: () {
                        onTap(profileIndex);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                width: 66,
                height: 107,
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () {
                    onTap(homeIndex);
                  },
                  child: Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, -3),
                          blurRadius: 6,
                        )
                      ],
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF3B7BE3),
                          Color(0xFF29388B),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Icon(
                        Iconsax.home_2,
                        color: themeData.colorScheme.secondary,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _BottomNavigationItem extends StatelessWidget {
  const _BottomNavigationItem({
    super.key,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final bool isActive;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(
              height: 4,
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isActive ? 24 : 0,
              height: 2,
              decoration: BoxDecoration(
                  color: isActive ? themeData.primaryColor : null),
            ),
          ],
        ),
      ),
    );
  }
}
