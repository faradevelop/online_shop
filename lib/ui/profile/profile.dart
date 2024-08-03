import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:online_shop/data/repository/auth_repository.dart';
import 'package:online_shop/data/repository/profile_repository.dart';
import 'package:online_shop/data/response/auth_info_response.dart';
import 'package:online_shop/ui/auth/start.dart';
import 'package:online_shop/ui/product/search/products.dart';
import 'package:online_shop/ui/profile/address/addresses.dart';
import 'package:online_shop/ui/profile/bloc/profile_bloc.dart';
import 'package:online_shop/ui/profile/edit_profile.dart';
import 'package:online_shop/ui/profile/orders_list.dart';
import 'package:online_shop/ui/widgets/appbar_widget.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';
import 'package:online_shop/ui/widgets/diolog_widget.dart';
import 'package:online_shop/ui/widgets/empty_view.dart';
import 'package:online_shop/ui/widgets/loading_widget.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ProfileBloc(profileRepository, authRepository);
        bloc.add(ProfileStarted());
        return bloc;
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileSuccess) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  AppbarWidget(
                    title: 'پروفایل',
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
                  ValueListenableBuilder<AuthInfo?>(
                    valueListenable: AuthRepository.authChangeNotifier,
                    builder:
                        (BuildContext context, AuthInfo? value, Widget? child) {

                      return value != null
                          ? _ProfileData(
                              name: value.userName,
                              mobile: value.userMobile,
                            )
                          : Container(
                              color: Colors.red,
                            );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ProfileMenuItem(
                    icon: Iconsax.map,
                    title: 'آدرس ها',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Addresses(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: CupertinoIcons.list_bullet_below_rectangle,
                    title: 'سفارشات',
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const OrdersList(),
                      ));
                    },
                  ),
                 /* ProfileMenuItem(
                    icon: Iconsax.user_cirlce_add,
                    title: 'دعوت از دوستان',
                    onTap: () {},
                  ),*/
                  ProfileMenuItem(
                    icon: Iconsax.logout,
                    title: 'خروج از حساب',
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return DialogWidget(onTap: () {
                            authRepository.logOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const Start(),
                                ),
                                (Route<dynamic> route) => false);
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            );
          } else if (state is Loading) {
            return const LoadingWidget();
          } else if (state is ProfileError) {
            return EmptyView(
                message: "خطای نامشخص",
                callToAction: ButtonWidget(
                    text: 'تلاش مجدد',
                    onPressed: () {
                      BlocProvider.of<ProfileBloc>(context)
                          .add(ProfileStarted());
                    }));
          } else {
            throw Exception('State is not supported');
          }
        },
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: themeData.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(11),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              offset: const Offset(0, 1),
              blurRadius: 3,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: themeData.primaryColor,
              size: 24,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: themeData.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            Icon(
              CupertinoIcons.right_chevron,
              color: themeData.primaryColor,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileData extends StatelessWidget {
  const _ProfileData({
    super.key,
    required this.name,
    required this.mobile,
  });

  final String name;
  final String mobile;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.only(top: 20, bottom: 14),
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeData.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 94,
            height: 94,
            decoration: BoxDecoration(
              color: themeData.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Icon(
                Iconsax.user,
                color: themeData.primaryColor,
                size: 30,
              ),
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Text(
            name ,
            style: themeData.textTheme.titleLarge!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            mobile ,
            style: themeData.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditProfile(
                        name: name,
                      ),
                    ),
                  );
                },
                child: Icon(
                  Iconsax.edit,
                  color: themeData.primaryColor,
                  size: 24,
                ),
              ),
            ),
          ),
          /*    GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditProfile(
                    name: name,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Iconsax.edit,
                  color: themeData.primaryColor,
                  size: 22,
                ),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  'ویرایش',
                  style: themeData.textTheme.labelMedium!
                      .copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )*/
        ],
      ),
    );
  }
}
