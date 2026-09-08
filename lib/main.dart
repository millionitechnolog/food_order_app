import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_order_app/bloc/orderbloc.dart';
import 'package:food_order_app/login/bloc/loginbloc.dart';
import 'package:food_order_app/login/login.dart';
import 'package:food_order_app/homepage.dart';
import 'package:food_order_app/services/dioclient.dart';
import 'package:food_order_app/services/services.dart';
import 'package:food_order_app/splashpage.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  DioClient.initialize(
    onTokenExpired: () {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
    },
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => Orderbloc()),
        BlocProvider(
          create: (context) => LoginBloc(
            authService: AuthService(
              dio: Dio(),
              storage: const FlutterSecureStorage(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        // home: const RotiLoginPage(),
        navigatorKey: navigatorKey,

        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/login': (context) => const RotiLoginPage(),
          '/home': (context) => const OrderHomePage(),
        },
      ),
    );
  }
}
