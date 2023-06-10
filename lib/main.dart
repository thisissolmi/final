import 'package:flutter/material.dart';
import 'package:mobileapp_project/app/wishprovider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/appstate.dart';
import 'app/appdirection.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppStatement>(
          create: (context) => AppStatement(),
        ),
        ChangeNotifierProvider<WishlistProvider>(
          create: (context) => WishlistProvider(),
        ),
      ],
      child: const ShrineApp(),
    ),
  );
}
