import 'package:flutter/material.dart';
import 'package:food_order_app/login.dart';
import 'package:food_order_app/homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RotiLoginPage(),
      initialRoute: '/home',
      routes: {'/home': (_) => const OrderHomePage()},
    );
  }
}
