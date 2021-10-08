import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx/main.dart';
import 'package:olx/model/Usuario.dart';
import 'package:olx/util/BotaoCustomizado.dart';
import 'package:olx/util/GeradorRotas.dart';
import 'package:olx/util/InputCustomizado.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  //TextEditingController _controllerEmailRecuperar = TextEditingController();

  String _mensagemErro = "";
  bool _status = false;
  bool _cadastrar = false;

  _cadastrarUsuario(Usuario usuario) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.createUserWithEmailAndPassword(
          email: usuario.email, password: usuario.senha);

      Navigator.pushNamedAndRemoveUntil(
          context, GeradorRotas.ROTA_INICIAL, (_) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        _status = false;
      });
      if (e.toString().contains("email-already-in-use")) {
        setState(() {
          _mensagemErro =
              "O endereço de email já está sendo usado em outra conta";
        });
      } else if (e.toString().contains("weak-password")) {
        print('A senha fornecida é muito fraca.');
        setState(() {
          _mensagemErro =
              "A senha fornecida é muito fraca. Ela precisa ter mais de 6 caracteres";
        });
      } else {
        setState(() {
          _mensagemErro =
              "Erro ao cadastrar novo usuário! Verifique os seus dados e tente novamente";
        });
      }
    } catch (e) {
      setState(() {
        _status = false;
      });
      setState(() {
        _mensagemErro =
            "Erro ao cadastrar novo usuário! Verifique os seus dados e tente novamente";
      });
    }
  }

  _logarUsuario(Usuario usuario) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signInWithEmailAndPassword(
          email: usuario.email, password: usuario.senha);

      //_redirecionarUsuario(userCredential.user!.uid);
      Navigator.pushNamedAndRemoveUntil(
          context, GeradorRotas.ROTA_INICIAL, (_) => false);
    } on FirebaseAuthException catch (erro) {
      setState(() {
        _status = false;
      });
      if (erro.toString().contains("user-not-found")) {
        setState(() {
          _mensagemErro = "Não existe usuário com esse endereço de e-mail";
        });
      } else if (erro.toString().contains("wrong-password")) {
        setState(() {
          _mensagemErro = "Senha incorreta";
        });
      } else if (erro.toString().contains("operation-not-allowed")) {
        setState(() {
          _mensagemErro = "Erro na conexão. Tente novamente mais tarde!";
        });
      } else if (erro.toString().contains("too-many-requests")) {
        setState(() {
          _mensagemErro =
              "Muitas requisições! Tente novamente mais tarde ou use outra conta";
        });
      } else {
        setState(() {
          _mensagemErro = "Falha no login. Por favor, tente novamente";
        });
      }
    }
  }

  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (EmailValidator.validate(email)) {
      if (senha.isNotEmpty && senha.length > 6) {
        setState(() {
          _status = true;
        });

        //Configurar usuário:
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        if (_cadastrar) {
          _cadastrarUsuario(usuario);
        } else {
          _logarUsuario(usuario);
        }
      } else {
        setState(() {
          _mensagemErro = "A senha precisa ter mais de 6 caracteres";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "E-mail incorreto";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var alturaDispositivo = MediaQuery.of(context).size.height;
    var alturaBarraStatus = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: temaPadrao.primaryColor,
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Seja bem-vindo!",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Entre com o seu e-mail e senha, ou realize o seu cadastro.",
                      style: TextStyle(fontSize: 15, color: Colors.white60),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            height: (alturaDispositivo - alturaBarraStatus) -130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(75),
              ),
            ),
            padding: EdgeInsets.all(10),
            child: Center(
              child: ListView(
                //primary: false,
                children: <Widget>[
                  SizedBox(height: 50,),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: InputCustomizado(
                      "Digite o seu e-mail",
                      Icon(Icons.email_outlined, color: Colors.black),
                      controller: _controllerEmail,
                      autofocus: true,
                      type: TextInputType.emailAddress,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: InputCustomizado(
                      "Digite uma senha",
                      Icon(Icons.vpn_key, color: Colors.black),
                      controller: _controllerSenha,
                      maxLinhas: 1,
                      obscure: true,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Logar"),
                      Switch(
                          value: _cadastrar,
                          onChanged: (bool valor) {
                            setState(() {
                              _cadastrar = valor;
                            });
                          }),
                      Text("Cadastrar"),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          //Abrir a página de recuperação de senha
                          Navigator.pushNamed(
                              context, GeradorRotas.ROTA_RECUPERAR_SENHA);
                        },
                        child: Text(
                          "Esqueci minha senha!",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(child: child, scale: animation);
                    },
                    child: _status
                        ? TextButton(
                            onPressed: () {},
                            child: CircularProgressIndicator(
                              color: Colors.deepPurple,
                            ),
                          )
                        : BotaoCustomizado(
                            texto: _cadastrar == false ? "Entrar" : "Cadastrar",
                            onPressed: _validarCampos,
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Center(
                      child: Text(
                        _mensagemErro,
                        style: TextStyle(
                          color: Colors.red[300],
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
