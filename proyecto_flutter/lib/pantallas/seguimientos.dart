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


class Seguimientos extends StatefulWidget {
  const Seguimientos({Key? key}) : super(key: key);

  @override
  State<Seguimientos> createState() => _SeguimientosState();
}

class _SeguimientosState extends State<Seguimientos> {


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

  final Stream<QuerySnapshot> _seguimientos =
  FirebaseFirestore.instance.collection('seguimientos').snapshots();

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



  @override
  Widget build(BuildContext context) {

    double alturaFondo = 95;
    double anchuraFondo = MediaQuery.of(context).size.width;
    double alturaAvatar = 70;
    double anchuraAvatar =70;

    bool esAmbassador = false;

    var providerSeguimientos = Provider.of<TodoProvider>(context);


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
                "Seguimientos (${providerSeguimientos.numSeguimientos}) ",
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
                        .collection("seguimientos")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            //snapshot.data!.docs[index].get('usuarioEmail'),
                            int numeroSeguimientos = snapshot.data!.docs.length;
                            WidgetsBinding.instance.addPostFrameCallback((t) {
                              Provider.of<TodoProvider>(context, listen: false)
                                  .cambiarNumSeguimientos(numeroSeguimientos);
                            });



                            String emailSeguido =
                            snapshot.data!.docs[index].get('usuarioSeguido');
                            String avatarSeguido =
                            snapshot.data!.docs[index].get('usuarioSeguidoAvatar');

                            String emailSeguidor =
                            snapshot.data!.docs[index].get('usuarioSeguidor');

                            String avatarSeguidor =
                            snapshot.data!.docs[index].get('usuarioSeguidorAvatar');


                            Timestamp fechaalta = snapshot.data!.docs[index]
                                .get('fechaInicioSeguimiento');

                            var date = fechaalta.toDate();
                            String myDate = DateFormat('dd/MM/yyyy,hh:mm').format(date);




                            //texto a buscar

                            if (emailSeguido.contains(controlador.text.toString()) || emailSeguidor.contains(controlador.text.toString()) ) {

                            } else {

                            }

                            return emailSeguido.contains(
                                controlador.text.toString()) || emailSeguidor.contains(controlador.text.toString())
                                ? Card(
                              elevation: 6,
                              child: Column(
                                children: [


                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,

                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width -40,
                                        height: 80,
                                        child: Text(
                                          "${emailSeguidor} \nha comenzado a seguir a \n${emailSeguido} ",


                                          style: TextStyle(
                                              color: Colors
                                                  .black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),




                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(avatarSeguidor)),
                                          )),
                                      SizedBox(width: 10,),
                                      Text("->",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                                      SizedBox(width: 10,),
                                      Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(avatarSeguido)),
                                          )),
                                    ],
                                  ),



                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,

                                    children: [
                                      const Text(
                                        "Fecha inicio seguimiento:",
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
                                    height: 30,
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
