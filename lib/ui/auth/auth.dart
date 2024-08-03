import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:online_shop/data/repository/auth_repository.dart';
import 'package:online_shop/ui/auth/bloc/auth_bloc.dart';
import 'package:online_shop/ui/root.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';
import 'package:online_shop/ui/widgets/input_widget.dart';

class Auth extends StatefulWidget {
  Auth({super.key, required this.loginMode});

  final bool loginMode;

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final TextEditingController nameController = TextEditingController(text: '');

  final TextEditingController mobileController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController passwordConfirmController =
      TextEditingController();

   bool currentLoginMode=true;

  @override
  void initState() {
    currentLoginMode = widget.loginMode;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: BlocProvider<AuthBloc>(
        create: (context) {
          final bloc = AuthBloc(authRepository);
          bloc.stream.forEach((state) {
            if (state is AuthSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const Root(),
                  ),
                  (Route<dynamic> route) => false);
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.exception.message)));
            }
          });

          bloc.add(AuthStarted());
          return bloc;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(right: 22, left: 22),
              child: BlocBuilder<AuthBloc, AuthState>(
                buildWhen: (previous, current) {
                  return current is AuthLoading ||
                      current is AuthInitial ||
                      current is AuthError;
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Image.asset(
                          'assets/images/logo_horiz.png',
                          width: 160,
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        currentLoginMode ? 'ورود' : 'ثبت نام',
                        style: themeData.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 14),
                      currentLoginMode
                          ? _LoginForm(
                              mobileController: mobileController,
                              passwordController: passwordController)
                          : _RegisterForm(
                              nameController: nameController,
                              mobileController: mobileController,
                              passwordController: passwordController,
                              passwordConfirmController:
                                  passwordConfirmController,
                            ),
                      const SizedBox(height: 40),
                      ButtonWidget(
                          loading: state is AuthLoading,
                          text: currentLoginMode ? 'ورود' : 'ثبت نام',
                          onPressed: () {
                            if (currentLoginMode) {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(LoginButtonIsClicked(
                                mobileController.text,
                                passwordController.text,
                              ));
                              /*  authRepository.login(mobileController.text,
                                  passwordController.text);*/
                            } else {
                              BlocProvider.of<AuthBloc>(context)
                                  .add(RegisterButtonIsClicked(
                                nameController.text,
                                mobileController.text,
                                passwordController.text,
                                passwordConfirmController.text,
                              ));
                            }
                          }),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentLoginMode
                                ? "حساب کاربری ندارید؟"
                                : "حساب کاربری دارید؟",
                            style: themeData.textTheme.bodyMedium,
                          ),
                          GestureDetector(
                            onTap: () {
                              /*Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const Register(),
                                ),
                              );*/
                              /*   BlocProvider.of<AuthBloc>(context)
                                  .add(AuthModeChangeIsClicked());*/
                              setState(() {
                                currentLoginMode = !currentLoginMode;
                              });
                            },
                            child: Text(
                              currentLoginMode ? " ثبت نام کنید" : " وارد شوید",
                              style: themeData.textTheme.bodyMedium!
                                  .apply(color: themeData.primaryColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({
    super.key,
    required this.mobileController,
    required this.passwordController,
  });

  final TextEditingController mobileController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          InputWidget(
            controller: mobileController,
            hint: 'شماره موبایل',
            icon: Iconsax.mobile,
          ),
          const SizedBox(height: 14),
          InputWidget(
            controller: passwordController,
            hint: 'رمز عبور',
            type: TextInputType.visiblePassword,
          ),
        ],
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm({
    super.key,
    required this.nameController,
    required this.mobileController,
    required this.passwordController,
    required this.passwordConfirmController,
  });

  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          InputWidget(
            controller: nameController,
            hint: 'نام و نام خانوادگی',
            icon: Iconsax.user,
          ),
          const SizedBox(height: 14),
          InputWidget(
            controller: mobileController,
            hint: 'شماره موبایل',
            icon: Iconsax.mobile,
          ),
          const SizedBox(height: 14),
          InputWidget(
            controller: passwordController,
            hint: 'رمز عبور',
            type: TextInputType.visiblePassword,
          ),
          const SizedBox(height: 14),
          InputWidget(
            controller: passwordConfirmController,
            hint: 'تکرار رمز عبور',
            type: TextInputType.visiblePassword,
          ),
        ],
      ),
    );
  }
}
