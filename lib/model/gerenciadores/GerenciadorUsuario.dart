import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:olx/model/Usuario.dart';
import 'package:olx/util/FirebaseErros.dart';

class GerenciadorUsuario extends ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore bancoDados = FirebaseFirestore.instance;
  Usuario usuarioLogado = Usuario();

  GerenciadorUsuario() {
    _verificarUsuario();
  }

  bool _carregando = false;
  bool get carregando => _carregando;
  set carregando(bool value){
    _carregando = value;
    notifyListeners();
  }

  Future<void> _verificarUsuario({User? user}) async {
    User? usuario;

    //Verificar se foi passado algum usuário:
    if (user != null) {
      usuario = user;
    } else {
      usuario = auth.currentUser; //pegar usuário autenticado
    }

    //Verificar se o usuário está autenticado:
    if (usuario != null) {
      //Pegar dados do usuário autenticado:
      //DocumentSnapshot documento = await bancoDados.collection("usuarios").doc(usuario.uid).get();
      //usuarioLogado = Usuario.fromDocumentSnapshot(documento);
      usuarioLogado.id = usuario.uid;
      usuarioLogado.email = usuario.email!;
    } else {
      //Não existe usuário autenticado!!!
    }

    notifyListeners(); //notificar mudanças
  }

  Future<void> entrar(
      {required Usuario usuario,
      required Function fracasso,
      required Function sucesso}) async {
    
    carregando = true;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha,
      );

      await _verificarUsuario(user: userCredential.user);

      sucesso("");
    } on FirebaseAuthException catch (erro) {
      fracasso(getErrorString(erro.code));
    }
    carregando = false;
  }

  Future<void> cadastrar(
      {required Usuario usuario,
      required Function fracasso,
      required Function sucesso}) async {

    carregando = true;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: usuario.email, password: usuario.senha);

      usuario.id = userCredential.user!.uid;

      await usuario.salvarDados();
      this.usuarioLogado = usuario;

      sucesso("");
    } on FirebaseAuthException catch (erro) {
      fracasso(getErrorString(erro.code));
    }
    carregando = false;
  }

  Future<void> sair() async {
    auth.signOut();
    usuarioLogado = Usuario();
    notifyListeners();
  }
}
