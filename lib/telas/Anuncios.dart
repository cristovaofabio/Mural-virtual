import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:olx/main.dart';
import 'package:olx/model/Anuncio.dart';
import 'package:olx/model/gerenciadores/GerenciadorAnuncio.dart';
import 'package:olx/model/gerenciadores/GerenciadorUsuario.dart';
import 'package:olx/util/Filtros.dart';
import 'package:olx/util/GeradorRotas.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

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

  _carregarItensDropDown() {
    //Carregar as categorias:
    _listaItensCategorias = Filtros.getCategorias();
    //Carregar os Estados:
    _listaItensEstados = Filtros.getEstados();
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropDown();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Todos os anúncios"),
        actions: <Widget>[
          //Mudar o menu popUp de acordo com o usuário:
          Consumer<GerenciadorUsuario>(
            builder: (_, gerenciadorUsuario, __) {
              if (gerenciadorUsuario.usuarioLogado.id.isNotEmpty) {
                _itensMenu = ["Meus anúncios", "Deslogar"];
              } else {
                _itensMenu = ["Entrar/Cadastrar"];
              }
              return PopupMenuButton<String>(
                onSelected: (String itemEscolhido) {
                  switch (itemEscolhido) {
                    case "Meus anúncios":
                      Navigator.pushNamed(
                          context, GeradorRotas.ROTA_MEUS_ANUNCIOS);
                      break;
                    case "Entrar/Cadastrar":
                      Navigator.pushNamedAndRemoveUntil(
                          context, GeradorRotas.ROTA_LOGIN, (_) => false);
                      break;
                    case "Deslogar":
                      gerenciadorUsuario.sair();
                      break;
                  }
                },
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
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Consumer<GerenciadorAnuncio>(builder: (_, gerenciadorAnuncio, __) {
              return Row(
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
                            gerenciadorAnuncio.estado = estado as String;
                            setState(() {
                              _itemSelecionadoEstado = estado;
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
                            gerenciadorAnuncio.categoria = categoria as String;
                            setState(() {
                              _itemSelecionadoCategoria = categoria;
                            });
                          },
                        ),
                      ),
                    ),
                  )
                ],
              );
            }),
            Consumer<GerenciadorAnuncio>(
              builder: (_, gerenciadorAnuncio, __) {
                List<Anuncio> todosAnuncios =
                    gerenciadorAnuncio.anunciosFiltrados;

                return Expanded(
                  child: StaggeredGridView.countBuilder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true, //A lista será a menor possívels
                    staggeredTileBuilder: (index) =>
                        StaggeredTile.count(2, index.isEven ? 2 : 1),
                    mainAxisSpacing: 4, //Espaçamento na horizontal
                    crossAxisSpacing: 4, //Espaçamento na vertical
                    crossAxisCount:
                        4, //Quantidade de unidades de medida (quadrados) na largura
                    itemCount: todosAnuncios.length,
                    itemBuilder: (BuildContext context, int index) {
                      Anuncio anuncio = todosAnuncios[index];

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
                          child: Hero(
                            tag: "${anuncio.id}",
                            child: Stack(
                              fit: StackFit.passthrough,
                              children: <Widget>[
                                Center(
                                  child: CircularProgressIndicator(
                                    color: temaPadrao.primaryColor,
                                  ),
                                ),
                                FadeInImage.memoryNetwork(
                                  placeholder: kTransparentImage,
                                  image: anuncio.fotos.first,
                                  fit: BoxFit.cover,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            /* StreamBuilder<QuerySnapshot>(
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
                            staggeredTileBuilder: (index) =>
                                StaggeredTile.count(2, index.isEven ? 2 : 1),
                            mainAxisSpacing: 4, //Espaçamento na horizontal
                            crossAxisSpacing: 4, //Espaçamento na vertical
                            crossAxisCount:
                                4, //Quantidade de unidades de medida (quadrados) na largura
                            itemCount: querySnapshot.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              List<DocumentSnapshot> anuncios =
                                  querySnapshot.docs.toList();
                              DocumentSnapshot item = anuncios[index];
                              Anuncio anuncio =
                                  Anuncio.fromDocumentSnapshot(item);

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
                                  child: Hero(
                                    tag: "${anuncio.id}",
                                    child: Image.network(
                                      anuncio.fotos[0],
                                      fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            color: temaPadrao.primaryColor,
                                          ),
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Text('Algum erro aconteceu!'),
                                    ),
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
            ), */
          ],
        ),
      ),
    );
  }
}
