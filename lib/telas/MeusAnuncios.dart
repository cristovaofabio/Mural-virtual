import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/model/Anuncio.dart';
import 'package:olx/util/GeradorRotas.dart';
import 'package:olx/util/ItemAnuncio.dart';
import 'package:olx/util/widget/MensagemCarregando.dart';
import 'package:olx/util/widget/MensagemErro.dart';
import 'package:olx/util/widget/MensagemNaoTemDados.dart';

class MeusAnuncios extends StatefulWidget {
  const MeusAnuncios({Key? key}) : super(key: key);

  @override
  _MeusAnunciosState createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore _bancoDados = FirebaseFirestore.instance;
  String? _idUsuarioLogado;

  Future _adicionarListenerAnuncios() async {
    await _recuperarDadosUsuario();

    final stream = _bancoDados
        .collection("meus_anuncios")
        .doc(_idUsuarioLogado)
        .collection("anuncios")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioAtual = auth.currentUser;

    _idUsuarioLogado = usuarioAtual!.uid;
  }

  _removerAnuncio(String id){
    _bancoDados
        .collection("meus_anuncios")
        .doc(_idUsuarioLogado)
        .collection("anuncios")
        .doc(id)
        .delete();

    _bancoDados
        .collection("anuncios")
        .doc(id)
        .delete();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus anúncios"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, GeradorRotas.ROTA_NOVO_ANUNCIO);
        },
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return MensagemCarregando(
                texto: "Carregando anúncios...",
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasError) {
                return MensagemErro(texto: "Erro ao carregar os dados");
              } else {
                QuerySnapshot? querySnapshot = snapshot.data;
                if (querySnapshot!.docs.length == 0) {
                  return MensagemNaoTemDados(
                      texto: "Não existem anúncios cadastrados!");
                } else {
                  return ListView.separated(
                    itemCount: querySnapshot.docs.length,
                    separatorBuilder: (context, indice) => Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                    itemBuilder: (context, indice) {
                      List<DocumentSnapshot> anuncios = querySnapshot.docs.toList();
                      DocumentSnapshot item = anuncios[indice];
                      Anuncio anuncio = Anuncio.fromDocumentSnapshot(item);

                      return ItemAnuncio(
                        anuncio: anuncio,
                        onPressedRemover: () {
                          showDialog(
                            context: context,
                            builder: (builder) {
                              return AlertDialog(
                                title: Text("Confirmar"),
                                content: Text("Deseja realmente excluir o anúncio?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Cancelar",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _removerAnuncio(anuncio.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Remover",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                }
              }
          }
        },
      ),
    );
  }
}
/*

ListView.builder(
  itemCount: 4,
  itemBuilder: (_, indice) {
    return ItemAnuncio();
  },
)
*/