import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:movmap_ns_admin/pantallas/login.dart';
import 'package:movmap_ns_admin/pantallas/verificar_email.dart';


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


  @override

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red,
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
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/app_icon.png")
                              )
                          ),
                        ),
                        SizedBox(height: 40,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                width: 120,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.red,
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
                            Container(
                                width: 120,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.red,
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

