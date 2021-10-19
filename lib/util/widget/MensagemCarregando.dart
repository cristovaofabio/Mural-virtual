import 'package:flutter/material.dart';
import 'package:olx/main.dart';

class MensagemCarregando extends StatelessWidget {

  final String texto;

  MensagemCarregando({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.texto,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          CircularProgressIndicator(
            color: temaPadrao.primaryColor,
          ),
        ],
      ),
    );
  }
}