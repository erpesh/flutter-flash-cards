import 'package:firebase_core/firebase_core.dart';
import 'package:flash_cards/firebase_options.dart';
import 'package:flash_cards/pages/auth/auth.dart';
import 'package:flash_cards/pages/create_set.dart';
import 'package:flash_cards/pages/home.dart';
import 'package:flash_cards/pages/library.dart';
import 'package:flash_cards/pages/profile.dart';
import 'package:flash_cards/pages/test_history.dart';
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

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// final routes = <String, WidgetBuilder>{
//   '/home': (_) => const HomePage(),
//   '/library': (_) => const LibraryPage(),
//   '/tests': (_) => const TestHistoryPage(),
//   '/profile': (_) => ProfilePage(),
// };

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AuthPage(),
      navigatorKey: navigatorKey,
      theme: Provider.of<ThemeProvider>(context).themeData,
      // routes: routes,
    );
  }
}

