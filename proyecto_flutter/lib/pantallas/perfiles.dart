import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:movmap_ns_admin/pantallas/login.dart';
import 'package:movmap_ns_admin/pantallas/verificar_email.dart';

import '../servicios_firebase/firestore_services_usuario.dart';
import '../styles/colors.dart';


class Perfiles extends StatefulWidget {
  const Perfiles({Key? key}) : super(key: key);

  @override
  State<Perfiles> createState() => _PerfilesState();
}

class _PerfilesState extends State<Perfiles> {


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

  @override
  Widget build(BuildContext context) {

    double alturaFondo = 95;
    double anchuraFondo = MediaQuery.of(context).size.width;
    double alturaAvatar = 70;
    double anchuraAvatar =70;

    bool esAmbassador = false;


    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              backgroundColor: Colors.black,
              title: const Text(
                "Perfiles de usuarios de Mov-Map ",
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
                            print("fecha alta ${fechaalta}");
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
                              print("añadir");
                            } else {
                              print("no añadir");
                            }

                            return email.contains(
                                controlador.text.toString()) ||
                                dN.contains(controlador.text.toString())
                                ? Card(
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
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        esAmbassador
                                            ? InkWell(
                                          onTap: () {
                                            ServiciosFirebaseUsuario()
                                                .updateUserAmbassadorUsuarios(email,
                                                false);
                                            ServiciosFirebaseUsuario()
                                                .updateUserAmbassadorPerfiles(email,
                                                false);
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    20),
                                                color:
                                                Colors.green),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                const Text(
                                                  "Ambassador",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .white,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                            : InkWell(
                                          onTap: () {
                                            ServiciosFirebaseUsuario()
                                                .updateUserAmbassadorUsuarios(email,
                                                true);
                                            ServiciosFirebaseUsuario()
                                                .updateUserAmbassadorPerfiles(email,
                                                true);
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    20),
                                                color: Colors.grey),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                const Text(
                                                  "Ambassador",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .white,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),


                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,

                                    children: [
                                      const Text(
                                        "Nombre:",
                                        style: TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 20,),
                                      Text(
                                        "${nombre}",
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
                                      const Text(
                                        "Sexo:",
                                        style: TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 20,),
                                      Text(
                                        "${sexo}",
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
                                      const Text(
                                        "Web:",
                                        style: TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 20,),
                                      Text(
                                        "${web}",
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
                                      const Text(
                                        "Plataforma:",
                                        style: TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 20,),
                                      Text(
                                        "${plataforma}",
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
                                      const Text(
                                        "Fecha alta:",
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
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Sobre mi:",
                                        style: TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,

                                    children: [
                                      const
                                      SizedBox(width: 20,),
                                      Container(
                                        width:MediaQuery.of(context).size.width -40,
                                        height:140,
                                        child: Text(
                                          "${sobremi}",
                                          maxLines: 10,
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
                                      Text(
                                        "Fondo del perfil:",
                                        style: TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width:MediaQuery.of(context).size.width -40,
                                    height:180,

                                    decoration:
                                    BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(fondo)
                                      )
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,

                                    children: [
                                      const Text(
                                        "Ciudad:",
                                        style: TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "${ciudad}",
                                        style: const TextStyle(
                                          color: Colors
                                              .black,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 20,),
                                      Text(
                                        "Pais:",
                                        style: TextStyle(
                                            color: Colors
                                                .black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 10,),
                                      Text(
                                        "${pais}",
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2.0),
                                    child: Center(
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              //bmx
                                              bmx?Container(
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage("assets/images/sports/bmx_grande.png")
                                                    )
                                                ),
                                              ):Container(),
                                              bmx?SizedBox(width: 2,):Container(),

                                              //moto
                                              moto?Container(
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage("assets/images/sports/moto_grande.png")
                                                    )
                                                ),
                                              ):Container(),
                                              moto?SizedBox(width: 2,):Container(),
                                              //mtb
                                              mtb?Container(
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage("assets/images/sports/mount_grande.png")
                                                    )
                                                ),
                                              ):Container(),
                                              mtb?SizedBox(width: 2,):Container(),
                                              //para
                                              para?Container(
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage("assets/images/sports/para_grande.png")
                                                    )
                                                ),
                                              ):Container(),
                                              para?SizedBox(width: 2,):Container(),
                                              //skate
                                              skate?Container(
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage("assets/images/sports/skate_grande.png")
                                                    )
                                                ),
                                              ):Container(),
                                              skate?SizedBox(width: 2,):Container(),
                                              //ski
                                              ski?Container(
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage("assets/images/sports/ski_grande.png")
                                                    )
                                                ),
                                              ):Container(),
                                              ski?SizedBox(width: 2,):Container(),
                                              //snow
                                              snow?Container(
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage("assets/images/sports/snow_grande.png")
                                                    )
                                                ),
                                              ):Container(),
                                              snow?SizedBox(width: 2,):Container(),
                                              //surf
                                              surf?Container(
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage("assets/images/sports/surf_grande.png")
                                                    )
                                                ),
                                              ):Container()

                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
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
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ],
            )));
  }
}
