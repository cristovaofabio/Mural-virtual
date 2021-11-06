import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:olx/main.dart';
import 'package:olx/model/Anuncio.dart';
import 'package:olx/model/gerenciadores/GerenciadorAnuncio.dart';
import 'package:olx/util/facade/Facade.dart';
import 'package:olx/util/GeradorRotas.dart';
import 'package:olx/util/widget/ItemAnuncio.dart';
import 'package:olx/util/widget/MensagemNaoTemDados.dart';
import 'package:provider/provider.dart';

class MeusAnuncios extends StatefulWidget {
  const MeusAnuncios({Key? key}) : super(key: key);

  @override
  _MeusAnunciosState createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore _bancoDados = FirebaseFirestore.instance;
  String? _idUsuarioLogado;
  late Facade _facade;

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
    _facade = new Facade(usuario: null);
    _idUsuarioLogado = await _facade.idUsuarioLogado();
  }

  Future<void> _removerAnuncio(Anuncio anuncio) async {
    _facade = new Facade(usuario: null, anuncio: anuncio);
    await _facade.removerAnuncio();
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

  _barraProgresso(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Aguarde!"),
          content: Row(
            children: [
              CircularProgressIndicator(
                color: temaPadrao.primaryColor,
              ),
              Container(
                margin: EdgeInsets.only(left: 5),
                child: Text("Excluíndo"),
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 2,
        );
      },
    );
  }

  _caixaAlerta(BuildContext context, Anuncio anuncio) {
    return showDialog(
      context: context,
      builder: (builder) {
        return AlertDialog(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text("Atenção!"),
          content: Text("Deseja realmente remover o anúncio?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Cancelar",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); //Fechar este alert dialog
                _barraProgresso(context); //Mostrar dialog de exclusão
                await _removerAnuncio(anuncio).then((_) {
                  Navigator.of(context).pop(); //Fechar dialog de exclusão
                });
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                decoration: BoxDecoration(
                  color: Colors.red[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Remover",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus anúncios"),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, GeradorRotas.ROTA_NOVO_ANUNCIO);
        },
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
      body: Consumer<GerenciadorAnuncio>(
        builder: (_, gerenciadorAnuncio, __) {
          if (gerenciadorAnuncio.meusAnuncios.isEmpty) {
            return MensagemNaoTemDados(
                texto: "Não existem anúncios cadastrados!");
          } else {
            List<Anuncio> meusAnuncios = gerenciadorAnuncio.meusAnuncios;
            return ListView.builder(
              itemCount: gerenciadorAnuncio.meusAnuncios.length,
              itemBuilder: (context, indice) {
                Anuncio anuncio = meusAnuncios[indice];

                return ItemAnuncio(
                  anuncio: anuncio,
                  onPressedRemover: () {
                    _caixaAlerta(context, anuncio);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
