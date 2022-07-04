import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movmap_ns_admin/pantallas/login.dart';

import 'package:package_info_plus/package_info_plus.dart';



class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  //INICIALIZAMOS LAS VARIABLES DE LA INFO QUE NOS DA EL PACKAGE GET_VERSION

  String _projectVersion = '';

  String _projectName = '';

  @override
  void initState() {
    super.initState();

    initPlatformState(); //#0004

    Future.delayed(Duration(seconds: 6), () {
      //#005
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(), //#0006
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    List yourList = [
      "fondo001.jpeg",
      "fondo002.jpeg",
      "fondo003.jpeg",
      "fondo004.jpeg",
      "fondo005.jpeg",
      "fondo006.jpeg",
    ];
    int randomIndex = Random().nextInt(yourList.length); //#0007
    print(yourList[randomIndex]);

    return WillPopScope(
        onWillPop: () async {
          print("presionado back");
          return false;
        },
      child: Scaffold(
          body: Stack(alignment: Alignment.bottomCenter, children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/splash/${yourList[randomIndex]}"),
                  fit: BoxFit.cover,
                ),
              ),
//        child: [Your content here],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: new BoxDecoration(
                        image: DecorationImage(
                          image: new AssetImage('assets/images/movmap_transparente1024.png'),
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.all(15.0),
                    padding: const EdgeInsets.all(3.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.red,
                        border: Border.all(color: Colors.red)),
                    child: Text(
                      "Ⓒ Mov-Map v${_projectVersion}",
                      style: TextStyle(
                          color: Colors.white,
                          backgroundColor: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ])),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  //CARGAMOS TODOS LOS DATOS QUE NOS OFRECE EL PACKAGE GET_VERSION
  initPlatformState() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    setState(() {

      _projectVersion = version;


      _projectName = "Mov-Map";
    });
  }
}