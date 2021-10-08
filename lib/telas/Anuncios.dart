import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:olx/main.dart';
import 'package:olx/model/Anuncio.dart';
import 'package:olx/util/Filtros.dart';
import 'package:olx/util/GeradorRotas.dart';
import 'package:olx/util/widget/MensagemCarregando.dart';
import 'package:olx/util/widget/MensagemErro.dart';
import 'package:olx/util/widget/MensagemNaoTemDados.dart';

class Anuncios extends StatefulWidget {
  const Anuncios({Key? key}) : super(key: key);

  @override
  _AnunciosState createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {
  List<DropdownMenuItem<String>> _listaItensEstados = [];
  List<DropdownMenuItem<String>> _listaItensCategorias = [];

  List<String> _itensMenu = [];
  String _itemSelecionadoEstado = "";
  String _itemSelecionadoCategoria = "";

  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore _bancoDados = FirebaseFirestore.instance;

  Future _adicionarListenerAnuncios() async {
    final stream = _bancoDados.collection("anuncios").snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  Future _filtrarAnuncios() async {
    Query query = _bancoDados.collection("anuncios");

    if (_itemSelecionadoEstado.isNotEmpty) {
      query = query.where("estado", isEqualTo: _itemSelecionadoEstado);
    }
    if (_itemSelecionadoCategoria.isNotEmpty) {
      query = query.where("categoria", isEqualTo: _itemSelecionadoCategoria);
    }
    final stream = query.snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _escolhaMenuItem(String itemEscolhido) {
    //print("Item escolhido: " + itemEscolhido);
    switch (itemEscolhido) {
      case "Meus anúncios":
        Navigator.pushNamed(context, GeradorRotas.ROTA_MEUS_ANUNCIOS);
        break;
      case "Entrar/Cadastrar":
        Navigator.pushNamedAndRemoveUntil(
            context, GeradorRotas.ROTA_LOGIN, (_) => false);
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    //Mudar para a tela de login:
    Navigator.pushNamedAndRemoveUntil(
        context, GeradorRotas.ROTA_INICIAL, (_) => false);
  }

  _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;

    if (usuarioLogado != null) {
      //Usuário logado:
      _itensMenu = ["Meus anúncios", "Deslogar"];
    } else {
      //Usuário não está logado:
      _itensMenu = ["Entrar/Cadastrar"];
    }
  }

  _carregarItensDropDown() {
    //Carregar as categorias:
    _listaItensCategorias = Filtros.getCategorias();
    //Carregar os Estados:
    _listaItensEstados = Filtros.getEstados();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
    _carregarItensDropDown();
    _adicionarListenerAnuncios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todos os anúncios"),
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (contexto) {
                //Constroi os ítens que serão exibidos
                return _itensMenu.map((String item) {
                  //Percorre os ítens da lista
                  return PopupMenuItem<String>(
                    //Exibe os ítens na forma de menu
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        iconEnabledColor: temaPadrao.primaryColor,
                        value: _itemSelecionadoEstado,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        items: _listaItensEstados,
                        onChanged: (estado) {
                          setState(() {
                            _itemSelecionadoEstado = estado as String;
                            _filtrarAnuncios();
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[200],
                  width: 2,
                  height: 50,
                ),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: Center(
                      child: DropdownButton(
                        iconEnabledColor: temaPadrao.primaryColor,
                        value: _itemSelecionadoCategoria,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        items: _listaItensCategorias,
                        onChanged: (categoria) {
                          setState(() {
                            _itemSelecionadoCategoria = categoria as String;
                            _filtrarAnuncios();
                          });
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
            StreamBuilder<QuerySnapshot>(
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
                        return Expanded(
                          child: StaggeredGridView.countBuilder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true, //A lista será a menor possívels
                            staggeredTileBuilder: (index) => StaggeredTile.count(2, index.isEven ? 2 : 1),
                            mainAxisSpacing: 4, //Espaçamento na horizontal
                            crossAxisSpacing: 4, //Espaçamento na vertical
                            crossAxisCount: 4, //Quantidade de unidades de medida (quadrados) na largura
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              List<DocumentSnapshot> anuncios = querySnapshot.docs.toList();
                              DocumentSnapshot item = anuncios[index];
                              Anuncio anuncio = Anuncio.fromDocumentSnapshot(item);

                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    GeradorRotas.ROTA_DETALHES_ANUNCIO,
                                    arguments: anuncio,
                                  );
                                },
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.network(
                                    anuncio.fotos[0],
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null){
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: temaPadrao.primaryColor,
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) => Text('Algum erro aconteceu!'),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
