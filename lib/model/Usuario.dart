import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  String id = "";
  String nome = "";
  String email = "";
  String senha = "";

  FirebaseFirestore _bancoDados = FirebaseFirestore.instance;

  Usuario();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"id": this.id, "email": this.email};
    return map;
  }

  Future<void> salvarDados() async {
    await _bancoDados.collection("usuarios").doc(this.id).set(toMap());
  }
}
