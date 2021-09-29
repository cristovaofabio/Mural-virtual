import 'package:flutter/material.dart';
import 'package:olx/model/Anuncio.dart';
import 'package:olx/telas/Anuncios.dart';
import 'package:olx/telas/DetalhesAnuncio.dart';
import 'package:olx/telas/Login.dart';
import 'package:olx/telas/MeusAnuncios.dart';
import 'package:olx/telas/NovoAnuncio.dart';
import 'package:olx/telas/RecuperarSenha.dart';
import 'package:olx/util/TransacaoAnimada.dart';

class GeradorRotas {
  static const String ROTA_HOME = "/home";
  static const String ROTA_LOGIN = "/login";
  static const String ROTA_RECUPERAR_SENHA = "/recuperarsenha";
  static const String ROTA_MEUS_ANUNCIOS = "/meusanuncios";
  static const String ROTA_NOVO_ANUNCIO = "/novoanuncio";
  static const String ROTA_DETALHES_ANUNCIO = "/detalhesanuncio";
  static const String ROTA_INICIAL = "/";

  static Route<dynamic> gerarRota(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case ROTA_INICIAL:
        return MaterialPageRoute(builder: (_) => Anuncios());
      case ROTA_LOGIN:
        return MaterialPageRoute(builder: (_) => Login());
      case ROTA_RECUPERAR_SENHA:
        return MaterialPageRoute(builder: (_) => RecuperarSenha());
      case ROTA_MEUS_ANUNCIOS:
        return TransacaoAnimada(widget: MeusAnuncios());
      /*MaterialPageRoute(builder: (_) => MeusAnuncios());*/
      case ROTA_NOVO_ANUNCIO:
        return MaterialPageRoute(builder: (_) => NovoAnuncio());
      case ROTA_DETALHES_ANUNCIO:
        return MaterialPageRoute(
            builder: (_) => DetalhesAnuncio(args as Anuncio));
      default:
        return _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Tela não encontrada"),
        ),
        body: Center(
          child: Text("Tela não encontrada"),
        ),
      );
    });
  }
}
