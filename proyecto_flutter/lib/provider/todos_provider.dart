import 'package:flutter/material.dart';

class TodoProvider extends ChangeNotifier {
  int numUsuarios = 0;
  int numPerfiles = 0;
  int numUbicaciones = 0;
  int numLogs = 0;
  int numSeguimientos = 0;
  int numAmistades = 0;

  void cambiarNumUsuarios(int s) {

    numUsuarios = s;
    notifyListeners();
  }
  void cambiarNumPerfiles(int s) {

    numPerfiles = s;
    notifyListeners();
  }

  void cambiarNumUbicaciones(int s) {

    numUbicaciones = s;
    notifyListeners();
  }

  void cambiarNumLogs(int s) {

    numLogs = s;
    notifyListeners();
  }
  void cambiarNumSeguimientos(int s) {

    numSeguimientos = s;
    notifyListeners();
  }

  void cambiarNumAmistades(int s) {

    numAmistades = s;
    notifyListeners();
  }

}