import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validadores/Validador.dart';

class RecuperarSenha extends StatefulWidget {
  const RecuperarSenha({Key? key}) : super(key: key);

  @override
  _RecuperarSenhaState createState() => _RecuperarSenhaState();
}

class _RecuperarSenhaState extends State<RecuperarSenha> {
  String _email = "";
  String _mensagemErro = "";
  bool _status = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _recuperarSenha(String emailRecuperar) async {
    setState(() {
      _status = true;
    });

    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      await auth.sendPasswordResetEmail(email: emailRecuperar).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: <Widget>[
                SizedBox(width: 17),
                Expanded(child: Text("Verifique a sua caixa de e-mail"))
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );
        setState(() {
          _status = false;
          _mensagemErro = "";
        });
      });
    } catch (erro) {
      if (erro.toString().contains("user-not-found")) {
        setState(() {
          _status = false;
          _mensagemErro = "Não existe usuário com esse endereço de e-mail";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recuperar Senha"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: TextFormField(
                      onSaved: (valor) {
                        _email = valor!;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: "Digite o seu e-mail",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (valor) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                            .add(Validar.EMAIL, msg: 'E-mail inválido')
                            .validar(valor);
                      },
                    ),
                  ),
                  _status
                      ? TextButton(
                          onPressed: () {},
                          child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                          ),
                        )
                      : TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!
                                  .save(); //Vai chamar o método onSaved
                              //Execute uma determinada ação
                              print("E-mail validado: $_email");
                              await _recuperarSenha(_email);
                            } else {
                              //O e-mail não é válido
                            }
                          },
                          child: Text(
                            "Recuperar senha",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
        ),
      ),
    );
  }
}
