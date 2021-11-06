import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:olx/model/Anuncio.dart';
import 'package:olx/model/Usuario.dart';
import 'package:olx/model/gerenciadores/GerenciadorUsuario.dart';

class GerenciadorAnuncio extends ChangeNotifier {
  final FirebaseFirestore _bancoDados = FirebaseFirestore.instance;
  StreamSubscription? _subscription;
  StreamSubscription? _subscriptionMeusAnuncios;

  late Usuario usuario;
  List<Anuncio> todosAnuncios = [];
  List<Anuncio> meusAnuncios = [];

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

  void atualizarUsuario(GerenciadorUsuario gerenciadorUsuario) {
    usuario = gerenciadorUsuario.usuarioLogado;
    meusAnuncios.clear();

    if (usuario.id.isNotEmpty) {
      _carregarItensCarrinho();
    }
  }

  void _carregarItensCarrinho() {

    _subscriptionMeusAnuncios = _bancoDados
        .collection("meus_anuncios")
        .doc(usuario.id)
        .collection("anuncios")
        .snapshots()
        .listen((event) {
          meusAnuncios.clear();
          for (final doc in event.docs) {
            meusAnuncios.add(Anuncio.fromDocumentSnapshot(doc));
          }
          notifyListeners();
        });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
    _subscriptionMeusAnuncios?.cancel();
  }
}
