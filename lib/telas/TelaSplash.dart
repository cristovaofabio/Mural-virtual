import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/util/GeradorRotas.dart';

class TelaSplash extends StatefulWidget {
  const TelaSplash({Key? key}) : super(key: key);

  @override
  _TelaSplashState createState() => _TelaSplashState();
}

class _TelaSplashState extends State<TelaSplash> {
  bool _repetirAnimacao = true;


  _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioAtual = auth.currentUser;

    if (usuarioAtual != null) {
      //Mudar para a página principal
      setState(() {
        _repetirAnimacao = false;
        print(_repetirAnimacao);
        //_chave.currentState!.reset();
      });
    } else {
      //Mudar para a tela de login:
      setState(() {
        _repetirAnimacao = false;
        print(_repetirAnimacao);
        //_chave.currentState!.reset();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _repetirAnimacao
                ? AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Carregando dados...'),
                    ],
                    isRepeatingAnimation: true,
                    onTap: () {
                      print("Tap Event");
                    },
                  )
                : AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Carregando dados...'),
                    ],
                    isRepeatingAnimation: false,
                    onFinished: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, GeradorRotas.ROTA_LOGIN, (_) => false);
                    },
                    onTap: () {
                      print("Tap Event");
                    },
                  )
          ],
        ),
      ),
    );
  }
}
