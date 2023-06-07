import 'package:flutter/material.dart';
import 'package:mobileapp_project/foodpage.dart/dessert.dart';
import 'package:mobileapp_project/foodpage.dart/japan.dart';
import '../home.dart';
import '../login.dart';
import '../foodpage.dart/china.dart';
import '../foodpage.dart/korea.dart';
import '../foodpage.dart/usfood.dart';
import 'package:mobileapp_project/addpage.dart';
import '../splashpage.dart';

class ShrineApp extends StatelessWidget {
  const ShrineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shrine',
        initialRoute: '/login',
        routes: {
          '/login': (BuildContext context) => const LoginPage(),
          '/': (BuildContext context) => const HomePage(),
          '/add': (context) => const ProductAddPage(),
          '/china': (context) => const ChinaPage(),
          '/Kor': (context) => const KoreanPage(),
          '/us': (context) => const EuFoodPage(),
          '/Jp': (context) => const JapanPage(),
          '/Ds': (context) => const DessertPage(),
        },
        theme: ThemeData(
          fontFamily: 'Ca',
          appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff9AB8E4), elevation: 0),
          scaffoldBackgroundColor: const Color(0xff9AB8E4),
        ));
  }
}
