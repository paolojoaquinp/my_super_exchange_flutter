import 'package:flutter/material.dart';
import 'package:my_super_exchange_flutter/core/config/splash_screen.dart';
import 'package:my_super_exchange_flutter/features/home/presentation/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => const HomeScreen(),
      },
      // home: Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Material App Bar'),
      //   ),
      //   body: const Center(
      //     child: Text('Hello World'),
      //   ),
      // ),
    );
  }
}