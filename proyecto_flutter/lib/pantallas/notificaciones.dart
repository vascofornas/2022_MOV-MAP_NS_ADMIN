import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:movmap_ns_admin/pantallas/login.dart';
import 'package:movmap_ns_admin/pantallas/logs.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/push_a_todos.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/push_a_un_usuario.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/textos_push_a_admins.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/textos_push_a_ambassadors.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/textos_push_a_bmx.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/textos_push_a_moto.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/textos_push_a_mtb.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/textos_push_a_para.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/textos_push_a_skate.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/textos_push_a_ski.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/textos_push_a_snow.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/textos_push_a_surf.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/textos_push_a_todos.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/textos_push_a_un_usuario.dart';
import 'package:movmap_ns_admin/pantallas/perfiles.dart';
import 'package:movmap_ns_admin/pantallas/ubicaciones.dart';
import 'package:movmap_ns_admin/pantallas/usuarios.dart';
import 'package:movmap_ns_admin/pantallas/verificar_email.dart';


import '../servicios_firebase/firestore_services_usuario.dart';
import '../styles/colors.dart';



class Notificaciones extends StatefulWidget {
  const Notificaciones({Key? key}) : super(key: key);

  @override
  State<Notificaciones> createState() => _NotificacionesState();
}

class _NotificacionesState extends State<Notificaciones> {

  //DATOS DEL USUARIO ACTUAL

  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  late bool esAdmin = false;

  final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
      .collection("usuarios")
      .doc(FirebaseAuth.instance.currentUser!.email)
      .snapshots();









  @override
  initState() {
    super.initState();
    checkEmailVerified();

    _init();







  }


  Future<void> checkEmailVerified() async{
    user = auth.currentUser!;
    await user.reload();
    if(user.emailVerified){
      print("usuario ha verificado su email");
    }
    else {
      print("usuario no ha verificado su email");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => VerificarEmail(), //#0006
          ));
    }

  }



  Future<void> salir() async {
    FirebaseAuth auth = FirebaseAuth.instance;


    await auth.signOut().then((value) {
      //regresamos a login
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(), //#0006
          ));

    });
  }
  Future<void> _init() async {
    print("push en _init");
    if (Platform.isIOS) {
      final settings = await FirebaseMessaging.instance.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        FirebaseMessaging.instance.subscribeToTopic('promos');
        FirebaseMessaging.instance.getToken().then((token) {
          print("token ios ${token}");

          // Print the Token in Console
        });
      }
    } else {
      FirebaseMessaging.instance.subscribeToTopic('promos');
      FirebaseMessaging.instance.getToken().then((token) {
        print("token android ${token}"); // Print the Token in Console

      });
    }
  }


  @override

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,


          title: Text("Notificaciones Push",style: TextStyle(color: Colors.white),),
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: _usersStream,
            builder: (context,  AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Text("Loading");
              } else if (snapshot.hasError) {
                return Text('Something went wrong');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              dynamic data = snapshot.data;
              bool esAdmin = data['usuarioEsAdministrador'];
              return  Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      esAdmin ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/images/ic_launcher_round.png")
                                  )
                              ),
                            ),
                          ),
                          SizedBox(height: 40,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: (){
                                 // ServiciosFirebaseUsuario().sendPushMessage("eK0F8hpx7EjIlym7zbtJFP:APA91bEnOClDqN9sCiKwOKG6Zq35-BmnUvACj63yAWhf-ITabG14iJ6f32yih8Hgmrv1nJKGLZ0xAiPJwVNjnFuO01wWFm4NxBem6cy6cNr0R2-Iu8YHiyr1yeF_PafkXs-fc7vvaoYq", "UASA", "ASD");

                                Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TextoPushATodos(), //#0006
                                      ));
                                },
                                child: Container(
                                    width: 145,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("A todos",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 14),),
                                    )
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PushAUnUsuario(), //#0006
                                      ));

                                },
                                child: Container(
                                    width: 145,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("A un usuario",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 14),),
                                    )
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TextoPushAAdmins(), //#0006
                                      ));
                                },
                                child: Container(
                                    width: 145,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Administradores",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 14),),
                                    )
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TextoPushAAmbassadors(), //#0006
                                      ));

                                },
                                child: Container(
                                    width: 145,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Ambassadors",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 14),),
                                    )
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TextoPushASkate(), //#0006
                                      ));

                                },
                                child: Container(
                                    width: 145,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Skate",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 14),),
                                    )
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TextoPushASurf(), //#0006
                                      ));

                                },
                                child: Container(
                                    width: 145,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Surf",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 14),),
                                    )
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TextoPushABMX(), //#0006
                                      ));
                                },
                                child: Container(
                                    width: 145,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("BMX",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 14),),
                                    )
                                ),
                              ),
                              InkWell(
                                onTap: (){

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TextoPushAMTB(), //#0006
                                      ));
                                },
                                child: Container(
                                    width: 145,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("MTB",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 14),),
                                    )
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TextoPushASnow(), //#0006
                                      ));
                                },
                                child: Container(
                                    width: 145,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Snow",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 14),),
                                    )
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TextoPushAMoto(), //#0006
                                      ));

                                },
                                child: Container(
                                    width: 145,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Motocross",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 14),),
                                    )
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TextoPushASki(), //#0006
                                      ));
                                },
                                child: Container(
                                    width: 145,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Ski",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 14),),
                                    )
                                ),
                              ),
                              InkWell(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TextoPushAPara(), //#0006
                                      ));

                                },
                                child: Container(
                                    width: 145,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Paragliding",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 14),),
                                    )
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                          :
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("no soy administrador"),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

