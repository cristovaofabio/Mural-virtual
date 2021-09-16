import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:olx/main.dart';
import 'package:olx/model/Anuncio.dart';
import 'package:olx/util/BotaoCustomizado.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalhesAnuncio extends StatefulWidget {
  Anuncio anuncio;
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

  _ligarTelefone(int telefone) async {
    if (await canLaunch("tel:" + telefone.toString())) {
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
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "R\$ ${_anuncio.preco}",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: temaPadrao.primaryColor),
                    ),
                    Text(
                      "${_anuncio.titulo}",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Descrição",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${_anuncio.descricao}",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),
                    Text(
                      "Contato",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
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
          Positioned(
            left: 16,
            right: 16,
            bottom: 10,
            child: BotaoCustomizado(
                texto: "Ligar",
                onPressed: () {
                  _ligarTelefone(_anuncio.telefone);
                }),
          ),
        ],
      ),
    );
  }
}
