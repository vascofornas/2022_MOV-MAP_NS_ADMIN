import 'dart:async';
import 'dart:convert';


import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movmap_ns_admin/pantallas/inicio_random.dart';


import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_localizations/flutter_localizations.dart';




main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();




  runApp(
    EasyLocalization(
        path: "idiomas",
        fallbackLocale: Locale("es", "ES"),
        saveLocale: true,
        supportedLocales: [
          Locale("en", "EN"),
          Locale("fr", "FR"),
          Locale("de", "DE"),
          Locale("es", "ES")
        ],
        child: MyApp()
    ),
  );
}
class MyApp extends StatefulWidget {


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }




  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home:  SplashScreen()
    );
  }
}








