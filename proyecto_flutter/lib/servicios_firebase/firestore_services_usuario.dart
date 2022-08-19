import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;




class ServiciosFirebaseUsuario   {



  final CollectionReference _usuarios =
  FirebaseFirestore.instance.collection('usuarios');

  final CollectionReference _perfiles = FirebaseFirestore.instance.collection('perfiles');

  Future<void> nuevoUsuario(String usuarioId, String usuarioEmail, String usuarioDisplayName, DateTime usuarioFechaAlta, String metodoAutenticacion) async {
    await _usuarios.doc(usuarioId).set({
      "usuarioId": usuarioId,
      "usuarioEmail": usuarioEmail,
      "usuarioDisplayName": usuarioDisplayName,
      "usuarioFechaAlta": usuarioFechaAlta,
      "usuarioMetodoAuth": metodoAutenticacion,
      "usuarioEsAdministrador": false,
      "usuarioEsAmbassador": false

    });
  }

  Future<void> updateUserEmailVerificado() {
    User? usuario = FirebaseAuth.instance.currentUser;
    var uid = usuario!.uid;
    return _usuarios
        .doc(usuario.email)
        .update({'usuarioEmailVerificado': true})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  Future<void> updateUserPerfilActualizado() {
    User? usuario = FirebaseAuth.instance.currentUser;
    var uid = usuario!.uid;
    return _usuarios
        .doc(usuario.email)
        .update({'usuarioActualizado': DateTime.now()})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  Future<void> updateUserActivo() {
    User? usuario = FirebaseAuth.instance.currentUser;
    var uid = usuario!.uid;
    return _usuarios
        .doc(usuario.email)
        .update({'usuarioActivo': true})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //UPDATE USER AMBASSADOR
  Future<void> updateUserAmbassadorUsuarios(String email, bool valor) {

    return _usuarios
        .doc(email)
        .update({'usuarioEsAmbassador': valor})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  Future<void> updateUserAmbassadorPerfiles(String email, bool valor) {

    return _perfiles
        .doc(email)
        .update({'esAmbassador': valor})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  //UPDATE USER ADMIN
  Future<void> updateUserAdministrador(String email, bool valor) {

    return _usuarios
        .doc(email)
        .update({'usuarioEsAdministrador': valor})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //UPDATE USER bloquear
  Future<void> updateUserActivoCambiar(String email, bool valor) {

    return _usuarios
        .doc(email)
        .update({'usuarioActivo': valor})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }


  Future<void> updateUserPerfilActualizadoTokenFb(String tokenFb) {
    User? usuario = FirebaseAuth.instance.currentUser;

    return _perfiles
        .doc(usuario!.email)
        .update({''
        'perfilActualizado': DateTime.now(),
      'tokenFb': tokenFb,
      'ultimoCambio': "Cambio de tokenFB"

    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  void sendPushMessage(String token, String title, String body) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAALISYRlg:APA91bFYb92enGcwlf-cv5JsmrrIysIGa2OsmZTxBgOmw13oGr2Lon7p5gcMy5mAtWUZoUpUc3pVIcRuY02jplmZxsNgox9TiCyageBYWluBdGckBRfXcRM9uOlUXpBDLg8_LCycaFHR',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }



}
