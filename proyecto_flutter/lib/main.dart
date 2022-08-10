import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:movmap_ns_admin/pantallas/inicio_random.dart';
import 'package:movmap_ns_admin/provider/todos_provider.dart';
import 'package:movmap_ns_admin/servicios_firebase/firestore_services_usuario.dart';
import 'package:movmap_ns_admin/styles/colors.dart';
import 'package:movmap_ns_admin/widgets/notification_badge.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';


import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'modelos/push_notification.dart';


//003
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  print("push en background message");
  print(
      'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

  // Parse the message received
  print('recibido en background3');
}



main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  //002
  print("002");
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);




  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),

      ],
      child: EasyLocalization(
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
    ),
  );
}
class MyApp extends StatefulWidget {


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  late final FirebaseMessaging _messaging;
  late int _totalNotifications;
  PushNotification? _notificationInfo;

  //INICIALIZAMOS UNA INSTANCIA DE FIREBASE MESSAGING
  Future<void> _init() async {
    print("push en _init");
    if (Platform.isIOS) {
      final settings = await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        FirebaseMessaging.instance.subscribeToTopic('promos');
        FirebaseMessaging.instance.getToken().then((token) {
          print("token ios ${token}");
          ServiciosFirebaseUsuario().updateUserPerfilActualizadoTokenFb(token!);
          // Print the Token in Console
        });
      }
    } else {
      FirebaseMessaging.instance.subscribeToTopic('promos');
      FirebaseMessaging.instance.getToken().then((token) {
        print("token android ${token}"); // Print the Token in Console
        ServiciosFirebaseUsuario().updateUserPerfilActualizadoTokenFb(token!);
      });
    }
  }
  //PREPARAMOS LA APP PARA RECIBIR PUSH EN FOREGROUND
  _init_foreground() {


    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification != null) {
        print("push app en foreground");
        print("Notification title ${notification.title}");
        print("Notification body ${notification.body}");

      }
    });
  }
  //PREPARAMOS LA APP PARA RECIBIR PUSH CON LA APP CERRADA

  checkForInitialMessage() async {

    print("push en _checkfor initialmessage");
    await Firebase.initializeApp();
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
        _totalNotifications++;
      });
    }
  }
  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    print("push registernotification");

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
            'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

        // Parse the message received
        print('recibido en background1');
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        setState(() {
          _notificationInfo = notification;
          _totalNotifications++;
        });

        if (_notificationInfo != null) {
          // For displaying the notification as an overlay
          print(
              'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

          // Parse the message received
          print('recibido en background2');
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: NotificationBadge(totalNotifications: _totalNotifications),
            subtitle: Text(_notificationInfo!.body!),
            background: AppColors.grisMovMap,
            duration: Duration(seconds: 15),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _init();
    _init_foreground();
    _totalNotifications = 0;
    registerNotification();
    checkForInitialMessage();

  }




  @override
  Widget build(BuildContext context) {


    return OverlaySupport.global(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home:  SplashScreen()
      ),
    );
  }
}








