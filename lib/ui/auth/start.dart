import 'package:flutter/material.dart';
import 'package:online_shop/data/repository/auth_repository.dart';
import 'package:online_shop/data/response/auth_info_response.dart';
import 'package:online_shop/ui/auth/auth.dart';
import 'package:online_shop/ui/widgets/button_widget.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F9FF),
      body: ValueListenableBuilder<AuthInfo?>(
        valueListenable: AuthRepository.authChangeNotifier,
        builder: (BuildContext context, AuthInfo? authState, Widget? child) {
         // bool authenticated = authState != null && authState.token.isNotEmpty;
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Center(
                  child: Image.asset(
                    'assets/images/logo.webp',
                    height: 120,
                  ),
                ),
                const Spacer(),
                SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.only(top: 50, bottom: 54),
                    height: MediaQuery.of(context).size.height / 3,
                    //3.2
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(45),
                          topRight: Radius.circular(45),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 0,
                            offset: const Offset(0, -6),
                          )
                        ]),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'به فروشگاه ما خوش آمدید',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          'لطفا برای ادامه یکی از گزینه های زیر را انتخاب کنید',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 22, left: 22),
                          child: Row(
                            children: [
                              Expanded(
                                child: ButtonWidget(
                                  text: 'ثبت نام',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Auth(loginMode: false,),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: ButtonWidget(
                                  text: 'ورود',
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Auth(loginMode: true,),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
