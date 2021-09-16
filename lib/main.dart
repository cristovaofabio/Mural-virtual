import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/telas/Anuncios.dart';
import 'package:olx/util/GeradorRotas.dart';

final ThemeData temaPadrao = ThemeData(
  primaryColor: Colors.deepPurple,
  accentColor: Colors.deepPurple[700],
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(
      color: Colors.black,
    ),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: "OLX",
    home: Anuncios(),
    theme: temaPadrao,
    initialRoute: "/",
    onGenerateRoute: GeradorRotas.gerarRota,
    debugShowCheckedModeBanner: false,
  ));
}
