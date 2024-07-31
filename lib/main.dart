import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/EditTaskScreen.dart';
import 'package:to_do_app/MyAppTheme.dart';
import 'package:to_do_app/home/HomeScreen.dart';
import 'package:to_do_app/providers/AppConfigProvider.dart';
import 'package:to_do_app/providers/ListProvider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseFirestore.instance.disableNetwork();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppConfigProvider()),
      ChangeNotifierProvider(create: (_) => ListProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppConfigProvider>(context);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
 feature/provider
      initialRoute: HomeScreen.screenRoute,
      routes: {
        HomeScreen.screenRoute: (context) => HomeScreen(),

      initialRoute: HomeScreen.screenRoute,
      routes: {
        HomeScreen.screenRoute: (context) => HomeScreen(),
 development
        EditTaskScreen.screenRoute: (context) => EditTaskScreen()
      },
      theme: MyAppTheme.lightMode,
      themeMode: provider.appTheme,
      darkTheme: MyAppTheme.DarkMode,
      locale: Locale(provider.appLanguage),
    );
  }
}
