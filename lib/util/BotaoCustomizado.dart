import 'package:flutter/material.dart';
import 'package:olx/main.dart';

class BotaoCustomizado extends StatelessWidget {
  final String texto;
  final Color corTexto;
  final VoidCallback onPressed;

  BotaoCustomizado(
      {required this.texto,
      this.corTexto = Colors.white,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: this.onPressed,
      child: Text(
        this.texto,
        style: TextStyle(
          color: this.corTexto,
          fontSize: 18,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: temaPadrao.primaryColor,
        padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
