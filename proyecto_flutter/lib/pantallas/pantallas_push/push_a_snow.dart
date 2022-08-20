import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:movmap_ns_admin/pantallas/login.dart';
import 'package:movmap_ns_admin/pantallas/verificar_email.dart';
import 'package:movmap_ns_admin/provider/todos_provider.dart';
import 'package:provider/provider.dart';

import '../../servicios_firebase/firestore_services_usuario.dart';




class PushASnow extends StatefulWidget {
  const PushASnow({Key? key, required this.titulo, required this.texto}) : super(key: key);
  final String titulo;
  final String texto;


  @override
  State<PushASnow> createState() => _PushASnowState();
}

class _PushASnowState extends State<PushASnow> {
  //DATOS DEL USUARIO ACTUAL

  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  late bool esAdmin = false;
  TextEditingController controlador = TextEditingController();
  String textoBuscado = "";
  int numeroUsuarios = 0;



  @override
  initState() {
    super.initState();
    checkEmailVerified();
    FirebaseFirestore.instance
        .collection('perfiles')
    .where('esSnow',isEqualTo: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("admin "+doc["email"]);
        numeroUsuarios++;
        WidgetsBinding.instance.addPostFrameCallback((t) {
          Provider.of<TodoProvider>(context, listen: false)
              .cambiarNumUsuarios(numeroUsuarios);
        });
        ServiciosFirebaseUsuario().sendPushMessage(doc["tokenFb"], widget.titulo, widget.texto);
      });
    });
  }



  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      print("usuario ha verificado su email");
    } else {
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
  Future<void> getNumero(int num) async{
    setState(() {
      numeroUsuarios = num;
    });
  }

  @override
  Widget build(BuildContext context) {


    var providerUsuarios = Provider.of<TodoProvider>(context);




      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.black,
          title: Text(
            "Push a Snowboarding",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Se han enviado ${numeroUsuarios} notificaciones Push")
            ],
          ),
        ),
      );
  }
}
