import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:movmap_ns_admin/pantallas/muro.dart';

import '../servicios_firebase/firestore_services_usuario.dart';

class VerificarEmail extends StatefulWidget {
  const VerificarEmail({Key? key}) : super(key: key);

  @override
  State<VerificarEmail> createState() => _VerificarEmailState();
}

class _VerificarEmailState extends State<VerificarEmail> {

  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;


  @override
  void initState() {
    // TODO: implement initState

    user = auth.currentUser!;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();

    });

    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: 180,
              height: 180,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/app_icon.png"))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: Text("emailverificacion".tr()+": ${user.email}",textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 16),),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkEmailVerified() async{
    user = auth.currentUser!;
    await user.reload();
    if(user.emailVerified){
      timer.cancel();
      ServiciosFirebaseUsuario().updateUserEmailVerificado();
      ServiciosFirebaseUsuario().updateUserPerfilActualizado();
      ServiciosFirebaseUsuario().updateUserActivo();

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Muro()));
    }

  }

}
