import 'package:flutter/material.dart';

class MensagemNaoTemDados extends StatelessWidget {
  
  final String texto;

  MensagemNaoTemDados({required this.texto});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
          this.texto,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
  }
}
