import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:olx/main.dart';
import 'package:olx/model/Anuncio.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesAnuncio extends StatefulWidget {
  final Anuncio anuncio;
  DetalhesAnuncio(this.anuncio);

  @override
  _DetalhesAnuncioState createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {
  late Anuncio _anuncio;

  List<Widget> _getListaImagens() {
    List<String> listaUrlImagens = _anuncio.fotos;
    return listaUrlImagens.map((url) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(url),
            fit: BoxFit.fitWidth,
          ),
        ),
      );
    }).toList();
  }

  _ligarTelefone(String telefone) async {
    if (await canLaunch("tel:" + telefone)) {
      await launch("tel:" + telefone.toString());
    } else {}
  }

  @override
  void initState() {
    super.initState();
    _anuncio = widget.anuncio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes do anúncio"),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              SizedBox(
                height: 250,
                child: Carousel(
                  images: _getListaImagens(),
                  dotSize: 6,
                  dotBgColor: Colors.transparent,
                  dotColor: Colors.white,
                  autoplay: true,
                  dotIncreasedColor: temaPadrao.primaryColor,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      "${_anuncio.titulo}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Preço:',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      "R\$ ${_anuncio.preco}",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: temaPadrao.primaryColor),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      "${_anuncio.descricao}",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        'Contato',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 66),
                      child: Text(
                        "${_anuncio.telefone}",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.phone),
        foregroundColor: Colors.white,
        backgroundColor: temaPadrao.primaryColor,
        onPressed: () {
          _ligarTelefone(_anuncio.telefone);
        },
        label: Text("Ligar"),
      ),
    );
  }
}
