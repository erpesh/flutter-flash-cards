import 'package:firebase_core/firebase_core.dart';
import 'package:flash_cards/firebase_options.dart';
import 'package:flash_cards/pages/auth/auth.dart';
import 'package:flash_cards/pages/create_set.dart';
import 'package:flash_cards/pages/home.dart';
import 'package:flash_cards/pages/library.dart';
import 'package:flash_cards/pages/profile.dart';
import 'package:flash_cards/pages/settings.dart';
import 'package:flash_cards/services/notifications.dart';
import 'package:flash_cards/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationServices.initialiseNotification();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp()
    )
  );
}

final routes = <String, WidgetBuilder>{
  '/home': (_) => const HomePage(),
  '/library': (_) => const LibraryPage(),
  '/profile': (_) => ProfilePage(),
  '/settings': (_) => const SettingsPage(),
  '/createSet': (_) => CreateSetPage(cardsSet: null),
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AuthPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      routes: routes,
    );
  }
}

