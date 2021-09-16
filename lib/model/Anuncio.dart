import 'package:cloud_firestore/cloud_firestore.dart';

class Anuncio {
  late String id;
  late String estado;
  late String categoria;
  late String titulo;
  late double preco;
  late int telefone;
  late String descricao;
  late List<String> fotos;

  Anuncio();

  Anuncio.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.id;
    this.estado = documentSnapshot["estado"];
    this.categoria = documentSnapshot["categoria"];
    this.titulo = documentSnapshot["titulo"];
    this.preco = documentSnapshot["preco"];
    this.telefone = documentSnapshot["telefone"];
    this.descricao= documentSnapshot["descricao"];
    this.fotos = List<String>.from(documentSnapshot["fotos"]);
  }

  Anuncio.gerarId() {
    FirebaseFirestore bancoDados = FirebaseFirestore.instance;
    CollectionReference anuncios = bancoDados.collection("meus_anuncios");

    this.id = anuncios.doc().id;

    this.fotos = [];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id"        : this.id,
      "estado"    : this.estado,
      "categoria" : this.categoria,
      "titulo"    : this.titulo,
      "preco"     : this.preco,
      "telefone"  : this.telefone,
      "descricao" : this.descricao,
      "fotos"     : this.fotos
    };
    return map;
  }
}
