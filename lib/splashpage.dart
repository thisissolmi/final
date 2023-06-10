// import 'package:flutter/material.dart';
// import 'package:mobileapp_project/app/appdirection.dart';
// import 'dart:async';
// import './login.dart';
// import './main.dart';
// import 'app/appstate.dart';

// class Splash extends StatefulWidget {
//   const Splash({super.key});

//   @override
//   State<Splash> createState() => _SplashState();
// }

// class _SplashState extends State<Splash> {
//   //이게 맞아
//   @override
//   void initState() {
//     super.initState();

//     Timer(
//       const Duration(milliseconds: 5600),
//       () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const ShrineApp(),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(154, 184, 228, 1),
//       body: SizedBox(
//         height: double.infinity,
//         width: double.infinity,
//         child: Image.asset('assets/images/real.gif'),
//       ),
//     );
//   }
// }
