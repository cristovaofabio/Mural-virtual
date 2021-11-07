import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:olx/model/Anuncio.dart';
import 'package:olx/model/Usuario.dart';

class GerenciadorMeusAnuncio extends ChangeNotifier {
  final FirebaseFirestore _bancoDados = FirebaseFirestore.instance;
  StreamSubscription? _subscriptionMeusAnuncios;

  Usuario? usuario;
  List<Anuncio> meusAnuncios = [];

  void atualizarUsuario(Usuario usuarioInformado) {
    this.usuario = usuarioInformado;
    meusAnuncios.clear();

    _subscriptionMeusAnuncios?.cancel();
    if (usuario!.id.isNotEmpty) {
      _carregarMeusAnuncios();
    }
  }

  void _carregarMeusAnuncios() {

    _subscriptionMeusAnuncios = _bancoDados
        .collection("meus_anuncios")
        .doc(usuario!.id)
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
    _subscriptionMeusAnuncios?.cancel();
  }
}
