import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olx/main.dart';

class InputCustomizado extends StatelessWidget {
  late final String label;
  late final bool obscure;
  late final bool autofocus;
  late final TextInputType type;
  late final Icon icone;
  late final TextCapitalization letras;

  final List<TextInputFormatter>? inputFormaters;
  final int? maxLinhas;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;
  final String? textoAjuda;
  final TextEditingController? controller;

  InputCustomizado(this.label, this.icone,
      {this.controller,
      this.obscure = false,
      this.autofocus = false,
      this.type = TextInputType.text,
      this.letras = TextCapitalization.none,
      this.inputFormaters,
      this.maxLinhas,
      this.textoAjuda,
      this.validator,
      this.onSaved});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      enableSuggestions: true,
      obscureText: this.obscure,
      autofocus: this.autofocus,
      keyboardType: this.type,
      textCapitalization: this.letras,
      inputFormatters: this.inputFormaters,
      maxLines: this.maxLinhas,
      onSaved: this.onSaved,
      validator: this.validator,
      decoration: InputDecoration(
        prefixIcon: this.icone,
        helperText: this.textoAjuda,
        contentPadding: EdgeInsets.fromLTRB(30, 15, 30, 15),
        labelText: this.label,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 1, color: Colors.orange),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 1, color: temaPadrao.primaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
