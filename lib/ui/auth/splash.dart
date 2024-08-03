import 'package:flutter/material.dart';
import 'package:online_shop/data/repository/auth_repository.dart';
import 'package:online_shop/ui/auth/start.dart';
import 'package:online_shop/ui/root.dart';

class Splash extends StatefulWidget {
  const Splash({
    super.key,
  });

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

/*

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      final authInfo = AuthRepository.authChangeNotifier.value;
      if (authInfo != null && authInfo.token.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Root()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Start()),
        );
      }
    });
  }
*/


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        final authInfo = AuthRepository.authChangeNotifier.value;
        if (authInfo != null && authInfo.token.isNotEmpty) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Root()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Start()),
          );
        }
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.asset(
              'assets/images/background.webp',
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.45),
            ),
            Center(
              child: Image.asset(
                'assets/images/logo.webp',
                height: 150,
              ),
            )
          ],
        ),
      ),
    );
  }
}



