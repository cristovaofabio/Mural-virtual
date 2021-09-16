import 'package:flutter/material.dart';

class MensagemErro extends StatelessWidget {

  final String texto;

  MensagemErro({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text(
          this.texto,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
