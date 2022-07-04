import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:movmap_ns_admin/pantallas/login.dart';
import 'package:movmap_ns_admin/pantallas/verificar_email.dart';

import '../styles/colors.dart';

class Usuarios extends StatefulWidget {
  const Usuarios({Key? key}) : super(key: key);

  @override
  State<Usuarios> createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  //DATOS DEL USUARIO ACTUAL

  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  late bool esAdmin = false;

  final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
      .collection("usuarios")
      .doc(FirebaseAuth.instance.currentUser!.email)
      .snapshots();

  final Stream<QuerySnapshot> _usuarios =
      FirebaseFirestore.instance.collection('usuarios').snapshots();

  @override
  initState() {
    super.initState();
    checkEmailVerified();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            "Usuarios de Mov-Map ",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body:
                Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              style: TextStyle(
                                
                              ),
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                                hintText: "Buscar usuario",
                                filled: true,
                                fillColor: Color.fromRGBO(235, 235, 245, 0.6),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>( // inside the <> you enter the type of your stream
                        stream: FirebaseFirestore.instance.collection("usuarios").snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    snapshot.data!.docs[index].get('usuarioEmail'),
                                  ),
                                );
                              },
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text('Error');
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                  ],
                )

    )
    );
  }
}
