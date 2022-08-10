import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:movmap_ns_admin/pantallas/login.dart';
import 'package:movmap_ns_admin/pantallas/perfiles.dart';
import 'package:movmap_ns_admin/pantallas/ubicaciones.dart';
import 'package:movmap_ns_admin/pantallas/usuarios.dart';
import 'package:movmap_ns_admin/pantallas/verificar_email.dart';


import '../servicios_firebase/firestore_services_usuario.dart';
import '../styles/colors.dart';



class Muro extends StatefulWidget {
  const Muro({Key? key}) : super(key: key);

  @override
  State<Muro> createState() => _MuroState();
}

class _MuroState extends State<Muro> {

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


  @override

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              //hacemos logout
              FirebaseAuth auth = FirebaseAuth.instance;
              auth.signOut().then((value) {
                //regresamos a login
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(), //#0006
                    ));

              });
            },
          ),

          title: Text("Administración de Mov-Map ",style: TextStyle(color: Colors.white),),
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
                                print("Abrir usuarios");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Usuarios(), //#0006
                                    ));
                              },
                              child: Container(
                                  width: 140,
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
                                    child: Text("Usuarios",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 18),),
                                  )
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                print("Abrir perfiles");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Perfiles(), //#0006
                                    ));

                              },
                              child: Container(
                                  width: 140,
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
                                    child: Text("Perfiles",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 18),),
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
                                print("Abrir ubicaciones");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Ubicaciones(), //#0006
                                    ));
                              },
                              child: Container(
                                  width: 140,
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
                                    child: Text("Ubicaciones",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 18),),
                                  )
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                print("Abrir lof");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Perfiles(), //#0006
                                    ));

                              },
                              child: Container(
                                  width: 140,
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
                                    child: Text("Log",textAlign: TextAlign.center, style: TextStyle(color: Colors.white,fontSize: 18),),
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
              );
            }),
      ),
    );
  }
}

