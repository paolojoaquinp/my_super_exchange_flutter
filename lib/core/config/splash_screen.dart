import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_super_exchange_flutter/features/home/presentation/page/home_screen.dart';


class SplashScreen extends StatelessWidget {
  final ValueNotifier<bool> _isTimeElapsed = ValueNotifier(false);
  SplashScreen({super.key}) {
    Future.delayed(const Duration(seconds: 3), () {
      _isTimeElapsed.value = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isTimeElapsed,
      builder: (context, isTimeElapsed, child) {
        if (isTimeElapsed) {
          Future.microtask(() {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 800),
                pageBuilder: (_, __, ___) => const HomeScreen(),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          });
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Text('Splash Screen'),
            // child: Lottie.asset(
            //   'assets/lotties/lottie-animation-newspaper.json',
            //   width: 200,
            //   height: 200,
            //   fit: BoxFit.contain
            // ),
          ),
        );
      },
    );
  }
}