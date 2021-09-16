import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class Filtros {
  static List<DropdownMenuItem<String>> getCategorias() {
    List<DropdownMenuItem<String>> listaItensCategorias = [];
    //Carregar as categorias:
    listaItensCategorias.add(DropdownMenuItem(
      child: Text(
        "Todas",
        style: TextStyle(color: Colors.deepPurple),
      ),
      value: "",
    ));
    listaItensCategorias.add(DropdownMenuItem(
      child: Text("Automóvel"),
      value: "auto",
    ));
    listaItensCategorias.add(DropdownMenuItem(
      child: Text("Imóvel"),
      value: "imovel",
    ));
    listaItensCategorias.add(DropdownMenuItem(
      child: Text("Eletrônicos"),
      value: "eletro",
    ));
    listaItensCategorias.add(DropdownMenuItem(
      child: Text("Moda"),
      value: "moda",
    ));
    listaItensCategorias.add(DropdownMenuItem(
      child: Text("Esportes"),
      value: "esportes",
    ));

    return listaItensCategorias;
  }

  static List<DropdownMenuItem<String>> getEstados() {
    List<DropdownMenuItem<String>> listaItensEstados = [];
    listaItensEstados.add(DropdownMenuItem(
      child: Text(
        "Região",
        style: TextStyle(color: Colors.deepPurple),
      ),
      value: "",
    ));
    //Carregar os Estados:
    for (var estado in Estados.listaEstadosSigla) {
      listaItensEstados.add(DropdownMenuItem(
        child: Text(estado),
        value: estado,
      ));
    }

    return listaItensEstados;
  }
}
