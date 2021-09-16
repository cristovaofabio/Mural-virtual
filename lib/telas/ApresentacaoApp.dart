import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:olx/util/GeradorRotas.dart';

class ApresentacaoApp extends StatefulWidget {
  const ApresentacaoApp({Key? key}) : super(key: key);

  @override
  _ApresentacaoAppState createState() => _ApresentacaoAppState();
}

class _ApresentacaoAppState extends State<ApresentacaoApp> {
  final introKey = GlobalKey<IntroductionScreenState>();

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('imagens/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return Scaffold(
      body: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.white,
        showDoneButton: true,
        showSkipButton: true,
        showNextButton: true,
        next: const Text("Próximo"),
        skip: const Text("Pular"),
        done: const Text("Ok", style: TextStyle(fontWeight: FontWeight.w600)),
        curve: Curves.fastLinearToSlowEaseIn,
        onDone: () {
          Navigator.pushNamedAndRemoveUntil(
              context, GeradorRotas.ROTA_LOGIN, (_) => false);
        },
        onSkip: () {
          Navigator.pushNamedAndRemoveUntil(
              context, GeradorRotas.ROTA_LOGIN, (_) => false);
        },
        dotsDecorator: const DotsDecorator(
          size: Size(10.0, 10.0),
          color: Color(0xFFBDBDBD),
	        activeColor: Colors.blue,
          activeSize: Size(22.0, 10.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        pages: [
          PageViewModel(
            title: "Titulo da primeira página",
            body:
                "Here you can write the description of the page, to explain someting...",
            image: _buildImage('acordo.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Titulo da segunda página",
            body:
                "Here you can write the description of the page, to explain someting...",
            image: _buildImage('calendario.png'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: "Titulo da terceira página",
            body:
                "Here you can write the description of the page, to explain someting...",
            image: _buildImage('seguranca.png'),
            decoration: pageDecoration,
          ),
        ],
      ),
    );
  }
}
