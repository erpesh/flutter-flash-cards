import 'package:firebase_core/firebase_core.dart';
import 'package:flash_cards/firebase_options.dart';
import 'package:flash_cards/pages/auth/auth.dart';
import 'package:flash_cards/pages/home.dart';
import 'package:flash_cards/pages/library.dart';
import 'package:flash_cards/pages/profile.dart';
import 'package:flash_cards/pages/settings.dart';
import 'package:flash_cards/theme/dark_mode.dart';
import 'package:flash_cards/theme/light_mode.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(name: 'dev projd' ,options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

final routes = <String, WidgetBuilder>{
  '/home': (_) => const HomePage(),
  '/library': (_) => const LibraryPage(),
  '/profile': (_) => ProfilePage(),
  '/settings': (_) => const SettingsPage(),
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AuthPage(),
      theme: lightMode,
      darkTheme: darkMode,
      routes: routes,
    );
  }
}

