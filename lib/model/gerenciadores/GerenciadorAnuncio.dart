import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:olx/model/Anuncio.dart';
import 'package:olx/model/Usuario.dart';

class GerenciadorAnuncio extends ChangeNotifier {
  final FirebaseFirestore _bancoDados = FirebaseFirestore.instance;
  StreamSubscription? _subscription;

  late Usuario usuario;
  List<Anuncio> todosAnuncios = [];

  String _estado = "";
  String _categoria = "";

  GerenciadorAnuncio() {
    _carregarTodosAnuncios();
  }

  String get estado => _estado;
  set estado(String value) {
    _estado = value;
    notifyListeners();
  }

  String get categoria => _categoria;
  set categoria(String value) {
    _categoria = value;
    notifyListeners();
  }

  Future<void> _carregarTodosAnuncios() async {
    _subscription = _bancoDados.collection('anuncios').snapshots().listen((snapshot) {
      todosAnuncios.clear();
      for (final DocumentSnapshot document in snapshot.docs) {
        todosAnuncios.add(Anuncio.fromDocumentSnapshot(document));
      }
      notifyListeners();
    });
  }

  List<Anuncio> get anunciosFiltrados {
    final List<Anuncio> anunciosFiltrados = [];

    if (estado.isEmpty && categoria.isEmpty) {
      anunciosFiltrados.addAll(todosAnuncios);
    } else if (estado.isNotEmpty && categoria.isEmpty) {
      anunciosFiltrados.addAll(
        todosAnuncios.where((anuncio) => anuncio.estado.contains(estado)),
      );
    } else if (estado.isNotEmpty && categoria.isNotEmpty) {
      anunciosFiltrados.addAll(
        todosAnuncios.where((anuncio) =>
            anuncio.estado == estado && anuncio.categoria.contains(categoria)),
      );
    } else if (estado.isEmpty && categoria.isNotEmpty) {
      anunciosFiltrados.addAll(
        todosAnuncios.where((anuncio) => anuncio.categoria.contains(categoria)),
      );
    }
    return anunciosFiltrados;
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
