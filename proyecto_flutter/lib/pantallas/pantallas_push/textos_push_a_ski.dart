import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/push_a_administradores.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/push_a_ambassadors.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/push_a_bmx.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/push_a_moto.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/push_a_mtb.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/push_a_ski.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/push_a_snow.dart';

import 'package:movmap_ns_admin/pantallas/pantallas_push/push_a_surf.dart';
import 'package:movmap_ns_admin/pantallas/pantallas_push/push_a_todos.dart';

import '../../styles/colors.dart';

class TextoPushASki extends StatefulWidget {
  const TextoPushASki({Key? key}) : super(key: key);

  @override
  State<TextoPushASki> createState() => _TextoPushASkiState();
}

class _TextoPushASkiState extends State<TextoPushASki> {
  TextEditingController tituloController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.black,
        title: Text(
          "Push a Ski",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(
                  top: 2.0, bottom: 2.0, left: 20, right: 20),
              child: TextField(
                controller: tituloController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.title,
                    size: 30,
                    color: AppColors.negroMovMap,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: AppColors.negroMovMap, width: 2.0),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: AppColors.negroMovMap, width: 2.0),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Título de la notificación push",
                ),
                onChanged: (text) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 2.0, bottom: 2.0, left: 20, right: 20),
              child: TextField(
                obscureText: false,
                controller: bodyController,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.text_format,
                    size: 30,
                    color: AppColors.negroMovMap,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: AppColors.negroMovMap, width: 2.0),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: AppColors.negroMovMap, width: 2.0),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  labelText: "Texto de la notificación push",
                ),
                onChanged: (text) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 60,
              child: ElevatedButton.icon(

                onPressed: ()  {

                  var titulo = tituloController.text.toString();
                  var texto = bodyController.text.toString();

                  if(titulo.isEmpty){
                    Fluttertoast.showToast(
                        msg: "Título obligatorio",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: AppColors.rojoMovMap,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                  else{
                    if(texto.isEmpty){
                      Fluttertoast.showToast(
                          msg: "Texto es obligatorio",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: AppColors.rojoMovMap,
                          textColor: Colors.white,
                          fontSize: 16.0);

                    }
                    else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PushASki(titulo: titulo,texto: texto,), //#0006
                          ));
                    }
                  }


                },
                label: Text(
                  'Enviar notificación Push',
                  style: const TextStyle(fontSize: 16),
                ),
                icon: const Icon(Icons.send),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      // Change your radius here
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
