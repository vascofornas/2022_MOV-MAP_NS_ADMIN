import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movmap_ns_admin/pantallas/muro.dart';

import 'package:movmap_ns_admin/styles/colors.dart';


import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  String errorMessage = "";

  bool estoyLogeado = false;

  Future<void> checkEstadoUsuario()async {
    var auth = FirebaseAuth.instance;
    if(auth.currentUser != null){
      print("estoy logeado");
      estoyLogeado = true;

      setState((){});

    }
    else{
      print("no estoy logeado");

    }

  }

  @override
  initState() {
    super.initState();
    checkEstadoUsuario();
  }
  //warning si se pulsa back button
  Future<bool?> showWarning(BuildContext context) async => showDialog<bool>(
      context: context, builder: (context) =>
      AlertDialog(
        title: Text("salirapp".tr()),
        actions: [
          ElevatedButton(
              onPressed: ()=> Navigator.pop(context, false),
              child: Text("no".tr())),
          ElevatedButton(
              onPressed: ()=> Navigator.pop(context, true),
              child: Text("si".tr()))
        ],
      )
  );

  //validamos si el email esta insertado
  String? validateEmail(String email){
    if(email == null || email.isEmpty){
      return 'E-mail address is required';
    }
    return null;
  }
  //validamos la longitud de la password
  String? validatePass(String pass){
    if(pass == null || pass.isEmpty){
      return 'Pass is required';
    }
    else{
      if(pass.length < 6){
        return 'Pass is short';

      }

    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("presionado back");
        final shouldPop = await showWarning(context);
        return shouldPop ?? false;
      },
      child: !estoyLogeado ? SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Column(
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
                      Text("ADMINISTRACION", style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 18),)
                    ],
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 2.0, bottom: 2.0, left: 20, right: 20),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          size: 30,
                          color: AppColors.rojoMovMap,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.rojoMovMap, width: 2.0),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.rojoMovMap, width: 2.0),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        labelText: "email".tr(),
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
                      obscureText: true,
                      controller: passController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.password,
                          size: 30,
                          color: AppColors.rojoMovMap,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.rojoMovMap, width: 2.0),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.rojoMovMap, width: 2.0),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        labelText: "password".tr(),
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
                      onPressed: () async {

                        var email = emailController.text.toString();
                        var pass = passController.text.toString();


                        //validamos email
                        var emailValido = validateEmail(email);
                        var passValido = validatePass(pass);
                        if (emailValido == 'E-mail address is required'){
                          print("email falta");
                          Fluttertoast.showToast(
                              msg: "emailrequired".tr().toString(),
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: AppColors.rojoMovMap,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                        else {
                          if(passValido == "Pass is required"){
                            Fluttertoast.showToast(
                                msg: "passrequired".tr().toString(),
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: AppColors.rojoMovMap,
                                textColor: Colors.white,
                                fontSize: 16.0);

                          }
                          else{
                            if(passValido == "Pass is short"){
                              Fluttertoast.showToast(
                                  msg: "passcorta".tr().toString(),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: AppColors.rojoMovMap,
                                  textColor: Colors.white,
                                  fontSize: 16.0);

                            }
                          }
                          try{
                            await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass).then((value) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Muro(), //#0006
                                  ));
                            });

                            final user = FirebaseAuth.instance.currentUser!;



                          } on FirebaseAuthException catch (error){
                            errorMessage = error.message!;
                            print("ERROR ${errorMessage}");

                            if(errorMessage == "There is no user record corresponding to this identifier. The user may have been deleted."){
                              Fluttertoast.showToast(
                                  msg: "emailnoexiste".tr().toString(),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: AppColors.rojoMovMap,
                                  textColor: Colors.white,
                                  fontSize: 16.0);

                            }
                            if(errorMessage == "The password is invalid or the user does not have a password."){
                              Fluttertoast.showToast(
                                  msg: "nopassword".tr().toString(),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: AppColors.rojoMovMap,
                                  textColor: Colors.white,
                                  fontSize: 16.0);

                            }

                            setState((){

                            });

                          }


                        }



                        setState((){

                        });

                      },
                      label: Text(
                        'login'.tr(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      icon: const Icon(Icons.login),
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

                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            context.setLocale(const Locale('es', 'ES')) ;
                            var a = context.locale.languageCode;
                            print("current locale ${a}");

                          });
                        },
                        child: context.locale.languageCode == "es"?const Chip(
                          label: Text(
                            'Español',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                        ):
                        const Chip(
                          label: Text(
                            'Español',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                        ),
                      ),
                      InkWell(
                          onTap: (){
                            setState(() {
                              context.setLocale(const Locale('en', 'EN')) ;

                            });
                          },
                        child: context.locale.languageCode == "en"?const Chip(
                          label: Text('English',style: TextStyle(color: Colors.white),),
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                        ):const Chip(
                          label: Text('English',style: TextStyle(color: Colors.white),),
                          backgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            context.setLocale(const Locale('fr', 'FR')) ;

                          });
                        },
                        child: context.locale.languageCode == "fr"?const Chip(
                          label: Text('Français',style: TextStyle(color: Colors.white),),
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                        ):const Chip(
                          label: Text('Français',style: TextStyle(color: Colors.white),),
                          backgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            context.setLocale(const Locale('de', 'DE')) ;

                          });
                        },
                        child: context.locale.languageCode == "de"?const Chip(
                          label: Text('Deutsch',style: TextStyle(color: Colors.white),),
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                        ):const Chip(
                          label: Text('Deutsch',style: TextStyle(color: Colors.white),),
                          backgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                ],
              ),
            ),
          ),
        ),
      ):
      Muro(),
    );
  }
}
