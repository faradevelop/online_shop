import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:online_shop/data/repository/auth_repository.dart';
import 'package:online_shop/data/repository/profile_repository.dart';
import 'package:online_shop/ui/profile/bloc/profile_bloc.dart';
import 'package:online_shop/ui/widgets/appbar_widget.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';
import 'package:online_shop/ui/widgets/input_widget.dart';
import 'package:online_shop/ui/widgets/snack_bar_widget.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.name});

  final String name;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  //bool _loading = false;
  //String? _editedName;

  // ProfileBloc? profileBloc;
  StreamSubscription? stateStreamSubscription;

  @override
  void initState() {
    nameController.text = widget.name;
    super.initState();
  }

  @override
  void dispose() {
    // profileBloc?.close();
    stateStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<ProfileBloc>(
        create: (context) {
          final bloc = ProfileBloc(profileRepository, authRepository);

          //  profileBloc = bloc;
          /*stateStreamSubscription = bloc.stream.listen((state) {
            if (state is UpdateProfileSuccess) {
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: SnackBarContentWidget(
                      msg: "پروفایل ویرابش شد",
                      icn: CupertinoIcons.check_mark_circled)));
              _loading = false;
            } else if (state is UpdateProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: SnackBarContentWidget(
                      msg: "خطا در ذخیره تغییرات",
                      icn: CupertinoIcons.exclamationmark_circle)));
              _loading = false;
            } else if (state is Loading) {
              _loading = true;
            }
          });*/

          return bloc;
        },
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: SnackBarContentWidget(
                      msg: "پروفایل ویرایش شد",
                      icn: CupertinoIcons.check_mark_circled)));
             // _loading = false;
            } else if (state is UpdateProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: SnackBarContentWidget(
                      msg: "خطا در ذخیره تغییرات",
                      icn: CupertinoIcons.exclamationmark_circle)));
             // _loading = false;
            } else if (state is Loading) {
             // _loading = true;
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppbarWidget(
                      title: 'ویرایش پروفایل',
                      backButton: true,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Form(
                        child: Column(
                          children: [
                            InputWidget(
                              controller: nameController,
                              hint: 'نام و نام خانوادگی',
                              icon: Iconsax.mobile,
                            ),
                            const SizedBox(height: 14),
                            InputWidget(
                              controller: oldPasswordController,
                              hint: 'رمز عبور قبلی',
                              type: TextInputType.visiblePassword,
                            ),
                            const SizedBox(height: 14),
                            InputWidget(
                              controller: newPasswordController,
                              hint: 'رمز عبور جدید',
                              type: TextInputType.visiblePassword,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: ButtonWidget(
                        text: 'ویرایش',
                        onPressed: () {
                          if (nameController.text.isNotEmpty &&
                              nameController.text != widget.name) {
                            BlocProvider.of<ProfileBloc>(context).add(
                                UpdateProfileStarted(
                                    nameController.text,
                                    oldPasswordController.text,
                                    newPasswordController.text));
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
