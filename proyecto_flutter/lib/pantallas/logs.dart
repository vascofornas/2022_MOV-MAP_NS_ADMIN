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

import '../servicios_firebase/firestore_services_usuario.dart';
import '../styles/colors.dart';


class Logs extends StatefulWidget {
  const Logs({Key? key}) : super(key: key);

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {


  //DATOS DEL USUARIO ACTUAL

  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  late bool esAdmin = false;
  TextEditingController controlador = TextEditingController();
  String textoBuscado = "";

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
            builder: (context) => const VerificarEmail(), //#0006
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
            builder: (context) => const LoginScreen(), //#0006
          ));
    });
  }
  bool esBmx = false;
  bool esMoto = false;
  bool esMtb = false;
  bool esPara = false;
  bool esSkate = false;
  bool esSki = false;
  bool esSnow = false;
  bool esSurf = false;
  int numeroLogs = 0;


  @override
  Widget build(BuildContext context) {

    double alturaFondo = 95;
    double anchuraFondo = MediaQuery.of(context).size.width;
    double alturaAvatar = 70;
    double anchuraAvatar =70;

    bool esAmbassador = false;
    var providerLogs = Provider.of<TodoProvider>(context);



    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.black,
              title: Text(
                "Logs (${providerLogs.numLogs}) ",
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: controlador,
                          onChanged: (value) {
                            textoBuscado = value.toString();
                            setState(() {});
                          },
                          style: const TextStyle(),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            hintText: "Buscar usuario",
                            filled: true,
                            fillColor: const Color.fromRGBO(235, 235, 245, 0.6),
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
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    // inside the <> you enter the type of your stream
                    stream: FirebaseFirestore.instance
                        .collection("logs")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            //snapshot.data!.docs[index].get('usuarioEmail'),
                            numeroLogs= snapshot.data!.docs.length;
                            WidgetsBinding.instance.addPostFrameCallback((t) {
                              Provider.of<TodoProvider>(context, listen: false)
                                  .cambiarNumLogs(numeroLogs);
                            });



                            String email =
                            snapshot.data!.docs[index].get('usuario');

                            String motivo= snapshot.data!.docs[index]
                                .get('motivoCambio');


                            Timestamp fechaalta = snapshot.data!.docs[index]
                                .get('logActualizado');

                            var date = fechaalta.toDate();
                            String myDate = DateFormat('dd/MM/yyyy,hh:mm').format(date);
                        



                            //texto a buscar

                            if (email.contains(controlador.text.toString()) ) {

                            } else {

                            }

                            return email.contains(
                                controlador.text.toString())
                                ? Card(
                              elevation: 6,
                              child: Column(
                                children: [


                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,

                                    children: [
                                      const Text(
                                        "Email:",
                                        style: TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 20,),
                                      Text(
                                        "${email}",
                                        style: const TextStyle(
                                          color: Colors
                                              .black,
                                          fontSize: 12,
                                        ),
                                      ),



                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Motivo:",
                                        style: TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,

                                    children: [
                                      const
                                      SizedBox(width: 20,),
                                      motivo.length >100?Container(
                                        width: MediaQuery.of(context).size.width -40,
                                        height: 120,
                                        child: Text(
                                          "${motivo}",
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ):Container(
                                        width: MediaQuery.of(context).size.width -40,
                                        height: 20,
                                        child: Text(
                                          "${motivo}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),



                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),


                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,

                                    children: [
                                      const Text(
                                        "Fecha log:",
                                        style: TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 20,),
                                      Text(
                                        "${myDate}",
                                        style: const TextStyle(
                                          color: Colors
                                              .black,
                                          fontSize: 12,
                                        ),
                                      ),



                                    ],
                                  ),

                                  SizedBox(
                                    height: 20,
                                  ),


                                ],
                              ),
                            )
                                : Container();
                          },
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text('Error');
                      } else {
                        return Center(child: Container(
                            width: 60,
                            height: 60,
                            child: const CircularProgressIndicator()));
                      }
                    },
                  ),
                ),
              ],
            )));
  }
}
