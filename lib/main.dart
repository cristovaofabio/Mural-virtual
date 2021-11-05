import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx/model/gerenciadores/GerenciadorUsuario.dart';
import 'package:olx/telas/Anuncios.dart';
import 'package:olx/util/GeradorRotas.dart';
import 'package:provider/provider.dart';

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
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GerenciadorUsuario(),
          lazy: false, //Carregar imediatamente o GerenciadorUsuarios
        ),
      ],
      child: MaterialApp(
        title: "AnunciAqui",
        home: Anuncios(),
        theme: temaPadrao,
        initialRoute: "/",
        onGenerateRoute: GeradorRotas.gerarRota,
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
