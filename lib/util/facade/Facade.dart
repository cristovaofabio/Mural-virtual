import 'package:firebase_auth/firebase_auth.dart';
import 'package:olx/model/Usuario.dart';

class Facade {
  FirebaseAuth auth = FirebaseAuth.instance;
  Usuario? usuario;

  Facade(Usuario? usuario) {
    this.usuario = usuario;
  }

  Future<void> cadastrarUsuario() async {
    await auth.createUserWithEmailAndPassword(
      email: this.usuario!.email,
      password: this.usuario!.senha,
    );
  }

  Future<void> logarUsuario() async {
    await auth.signInWithEmailAndPassword(
      email: this.usuario!.email,
      password: this.usuario!.senha,
    );
  }

  Future<void> deslogarUsuario() async {
    await auth.signOut();
  }

  Future<bool> usuarioLogado() async {
    User? usuarioLogado = auth.currentUser;
    if (usuarioLogado == null) {
      return false;
    } else {
      return true;
    }
  }
  Future<String> idUsuarioLogado() async{
    User? usuarioAtual = auth.currentUser;
    return usuarioAtual!.uid;
  }
}
