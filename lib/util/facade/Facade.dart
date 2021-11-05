import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:olx/model/Anuncio.dart';
import 'package:olx/model/Usuario.dart';

class Facade {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _bancoDados = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Usuario? usuario;
  Anuncio? anuncio;

  Facade({Usuario? usuario, Anuncio? anuncio}) {
    this.usuario = usuario;
    this.anuncio = anuncio;
  }

  Future<void> cadastrarUsuario() async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: this.usuario!.email,
      password: this.usuario!.senha,
    );

    this.usuario!.id = userCredential.user!.uid;

    _bancoDados
        .collection("usuarios")
        .doc(userCredential.user!.uid)
        .set(usuario!.toMap());
  }

  Future<UserCredential> logarUsuario() async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: this.usuario!.email,
      password: this.usuario!.senha,
    );
    return userCredential;
  }

  Future<void> deslogarUsuario() async {
    await _auth.signOut();
  }

  Future<bool> usuarioLogado() async {
    User? usuarioLogado = _auth.currentUser;
    if (usuarioLogado == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<String> idUsuarioLogado() async {
    User? usuarioAtual = _auth.currentUser;
    return usuarioAtual!.uid;
  }

  Future<void> salvarAnuncio() async {
    await idUsuarioLogado().then((idUsuario) async {
      await _bancoDados
          .collection("meus_anuncios")
          .doc(idUsuario)
          .collection("anuncios")
          .doc(this.anuncio!.id)
          .set(this.anuncio!.toMap());

      await _bancoDados
          .collection("anuncios")
          .doc(this.anuncio!.id)
          .set(this.anuncio!.toMap());
    });
  }

  Future<void> removerAnuncio() async {
    String id = anuncio!.id;
    List<String> fotos = anuncio!.fotos;
    String idUsuario = await idUsuarioLogado();

    //Remover anúncio do Firestore
    _bancoDados
        .collection("meus_anuncios")
        .doc(idUsuario)
        .collection("anuncios")
        .doc(id)
        .delete();
    _bancoDados.collection("anuncios").doc(id).delete();

    //Remover imagens do Storage:
    for (String foto in fotos) {
      try {
        final ref = _storage.refFromURL(foto);
        await ref.delete();
      } catch (erro) {}
    }
  }
}
