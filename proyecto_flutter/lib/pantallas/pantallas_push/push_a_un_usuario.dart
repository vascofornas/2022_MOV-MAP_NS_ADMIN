import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:movmap_ns_admin/pantallas/login.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/textos_push_a_un_usuario.dart';
import 'package:movmap_ns_admin/pantallas/verificar_email.dart';
import 'package:movmap_ns_admin/provider/todos_provider.dart';
import 'package:provider/provider.dart';

import '../../servicios_firebase/firestore_services_usuario.dart';




class PushAUnUsuario extends StatefulWidget {
  const PushAUnUsuario({Key? key}) : super(key: key);

  @override
  State<PushAUnUsuario> createState() => _PushAUnUsuarioState();
}

class _PushAUnUsuarioState extends State<PushAUnUsuario> {


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
  int numeroPerfiles = 0;

  @override
  Widget build(BuildContext context) {

    double alturaFondo = 95;
    double anchuraFondo = MediaQuery.of(context).size.width;
    double alturaAvatar = 70;
    double anchuraAvatar =70;

    bool esAmbassador = false;

    var providerPerfiles = Provider.of<TodoProvider>(context);


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
                "Usuarios (${providerPerfiles.numUsuarios}) ",
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
                        .collection("perfiles")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            //snapshot.data!.docs[index].get('usuarioEmail'),
                            numeroPerfiles = snapshot.data!.docs.length;

                            WidgetsBinding.instance.addPostFrameCallback((t) {
                              Provider.of<TodoProvider>(context, listen: false)
                                  .cambiarNumUsuarios(numeroPerfiles);
                            });
                            var esAmbassador = snapshot.data!.docs[index]
                                .get('esAmbassador');

                            String email =
                            snapshot.data!.docs[index].get('email');
                            String dN = snapshot.data!.docs[index]
                                .get('alias');
                            String ciudad = snapshot.data!.docs[index]
                                .get('ciudad');
                            String pais = snapshot.data!.docs[index]
                                .get('pais');
                            String nombre = snapshot.data!.docs[index]
                                .get('nombre');
                            String sexo = snapshot.data!.docs[index]
                                .get('sexo');
                            String web= snapshot.data!.docs[index]
                                .get('web');
                            String plataforma = snapshot.data!.docs[index]
                                .get('plataforma');
                            String sobremi = snapshot.data!.docs[index]
                                .get('sobreMi');
                            String fondo = snapshot.data!.docs[index]
                                .get('fondoPerfil');
                            Timestamp fechaalta = snapshot.data!.docs[index]
                                .get('fechaAlta');

                            var date = fechaalta.toDate();
                            String myDate = DateFormat('dd/MM/yyyy,hh:mm').format(date);


                            var bmx = snapshot.data!.docs[index]
                                .get('esBmx');
                            if(bmx){
                              esBmx =true;
                            }
                            var mtb = snapshot.data!.docs[index]
                                .get('esMtb');
                            if(mtb){
                              esMtb =true;
                            }
                            var moto = snapshot.data!.docs[index]
                                .get('esMoto');
                            if(moto){
                              esMoto =true;
                            }
                            var skate = snapshot.data!.docs[index]
                                .get('esSkate');
                            if(skate){
                              esSkate =true;
                            }
                            var para = snapshot.data!.docs[index]
                                .get('esPara');
                            if(para){
                              esPara =true;
                            }
                            var surf = snapshot.data!.docs[index]
                                .get('esSurf');
                            if(surf){
                              esSurf =true;
                            }
                            var ski = snapshot.data!.docs[index]
                                .get('esSki');
                            if(ski){
                              esSki =true;
                            }
                            var snow = snapshot.data!.docs[index]
                                .get('esSnow');
                            if(snow){
                              esSnow =true;
                            }

                            //texto a buscar

                            if (email.contains(controlador.text.toString()) ||
                                dN.contains(controlador.text.toString())) {

                            } else {

                            }

                            return email.contains(
                                controlador.text.toString()) ||
                                dN.contains(controlador.text.toString())
                                ? InkWell(
                              onTap: (){
                                print("usuario seleccionado ${snapshot
                                    .data!.docs[index]
                                    .get('email')}");
                                print("usuario seleccionado ${snapshot
                                    .data!.docs[index]
                                    .get('tokenFb')}");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TextoPushAUno(tokenFb: snapshot
                                          .data!.docs[index]
                                          .get('tokenFb'),email: snapshot
                                          .data!.docs[index]
                                          .get('email'),), //#0006
                                    ));
                              },
                                  child: Card(
                              elevation: 6,
                              child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(snapshot
                                                        .data!.docs[index]
                                                        .get(
                                                        'avatar'))),
                                              )),
                                          Padding(
                                            padding:
                                            const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Text(snapshot
                                                    .data!.docs[index]
                                                    .get(
                                                    'alias')),
                                                Text(snapshot
                                                    .data!.docs[index]
                                                    .get('email'),style: const TextStyle(fontSize: 12),),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),





                                  ],
                              ),
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
