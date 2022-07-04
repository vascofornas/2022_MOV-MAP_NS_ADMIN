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






  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('usuarios').doc(user.email).snapshots(),
        builder:  (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Scaffold(body: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                body: Text("Loading"));
          }
          {
            //recibimps tpdps los datos del usuario

            var email = snapshot.data.data()['usuarioEmail'];
            var alias= snapshot.data.data()['usuarioDisplayName'];

            return Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                      child: Text("bienvenido ${alias}")

                  ),
                  SizedBox(
                    height: 50,
                  ),
                  InkWell(
                      onTap: () async {
                        //hacemos logout
                        FirebaseAuth auth = FirebaseAuth.instance;
                        await auth.signOut().then((value) {
                          //regresamos a login
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(), //#0006
                              ));

                        });


                      },
                      child: Text("LOGOUT"))
                ],
              ),
            );
          }
        } );
  }
}
