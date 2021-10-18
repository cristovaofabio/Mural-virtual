import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:olx/model/Anuncio.dart';
import 'package:olx/util/widget/BotaoCustomizado.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:olx/util/Filtros.dart';
import 'package:olx/util/InputCustomizado.dart';
import 'package:validadores/Validador.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({Key? key}) : super(key: key);

  @override
  _NovoAnuncioState createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  final _formKey = GlobalKey<FormState>();
  List<XFile> _listaImagens = [];
  Anuncio _anuncio = Anuncio.gerarId();
  FirebaseFirestore _bancoDados = FirebaseFirestore.instance;

  List<DropdownMenuItem<String>> _listaItensEstados = [];
  List<DropdownMenuItem<String>> _listaItensCategorias = [];

  String _itemSelecionadoEstado = "";
  String _itemSelecionadoCategoria = "";
  String? _idUsuarioLogado;

  bool _status = false;

  final TextEditingController _controllerTitulo = TextEditingController();
  final TextEditingController _controllerPreco = TextEditingController();
  final TextEditingController _controllerTelefone = TextEditingController();
  final TextEditingController _controllerDescricao = TextEditingController();

  Future _selecionarImagemGaleria() async {
    final ImagePicker _picker = ImagePicker();
    XFile? imagemSelecionada;
    //recuperar imagem da galeria
    imagemSelecionada = await _picker.pickImage(source: ImageSource.gallery);
    if (imagemSelecionada != null) {
      _listaImagens.add(imagemSelecionada);

      setState(() {
        _listaImagens = _listaImagens;
      });
    }
  }

  _salvarAnuncioFirestore() async {
    await _bancoDados
        .collection("meus_anuncios")
        .doc(_idUsuarioLogado)
        .collection("anuncios")
        .doc(_anuncio.id)
        .set(_anuncio.toMap());

    await _bancoDados
        .collection("anuncios")
        .doc(_anuncio.id)
        .set(_anuncio.toMap());

    setState(() {
      _status = false;
      _itemSelecionadoEstado = "";
      _itemSelecionadoCategoria = "";
      _controllerTitulo.text ="";
      _controllerPreco.text ="";
      _controllerTelefone.text ="";
      _controllerDescricao.text ="";
      _anuncio = Anuncio.gerarId();
      _listaImagens.clear();
    });
  }

  _salvarAnuncio() async {
    setState(() {
      _status = true;
    });
    //Upload das imagens:
    await _uploadImagens();
  }

  Future _uploadImagens() async {
    //Referenciar arquivo:
    FirebaseStorage armazem = FirebaseStorage.instance;
    Reference pastaRaiz = armazem.ref();

    int contador = 0;

    for (var imagem in _listaImagens) {
      String nomeImagem = DateTime.now().microsecondsSinceEpoch.toString();

      Reference arquivo = pastaRaiz
          .child("meus_anuncios")
          .child(_anuncio.id)
          .child(nomeImagem + ".jpg");

      //Fazer o upload da imagem
      UploadTask task = arquivo.putFile(File(imagem.path));
      //Controlar o progresso do upload:
      task.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        if (taskSnapshot.state == TaskState.running) {
        } else if (taskSnapshot.state == TaskState.success) {
          //Recuperar url da imagem:
          String url = await taskSnapshot.ref.getDownloadURL();
          _anuncio.fotos.add(url);
          contador = contador + 1;

          if (contador == _listaImagens.length) {
            //Salvar anúncio no Firestore:
            _salvarAnuncioFirestore();
          }
        }
      });
    }
  }

  _carregarItensDropDown() {
    //Carregar as categorias:
    _listaItensCategorias = Filtros.getCategorias();
    //Carregar os Estados:
    _listaItensEstados = Filtros.getEstados();
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioAtual = auth.currentUser;

    _idUsuarioLogado = usuarioAtual!.uid;
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropDown();
    _recuperarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Novo anúncio"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FormField<List>(
                  initialValue: _listaImagens,
                  validator: (imagens) {
                    if (imagens!.length == 0) {
                      return "É necessário selecionar uma imagem";
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _listaImagens.length + 1,
                            itemBuilder: (contexto, indice) {
                              if (indice == _listaImagens.length) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      _selecionarImagemGaleria();
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[400],
                                      radius: 50,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Icon(
                                            Icons.add_a_photo,
                                            size: 35,
                                            color: Colors.grey[100],
                                          ),
                                          Text(
                                            "Adicionar",
                                            style: TextStyle(
                                              color: Colors.grey[100],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                              if (_listaImagens.length > 0) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Image.file(File(
                                                  _listaImagens[indice].path)),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _listaImagens
                                                        .removeAt(indice);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "Excluir",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: FileImage(
                                          File(_listaImagens[indice].path)),
                                      child: Container(
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.2),
                                        alignment: Alignment.bottomRight,
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                          ),
                        ),
                        if (state.hasError)
                          Container(
                            child: Text(
                              "[${state.errorText}]",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                          )
                      ],
                    );
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoEstado,
                          //hint: Text("Estados"),
                          onSaved: (estado) {
                            _anuncio.estado = estado as String;
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          items: _listaItensEstados,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo obrigatório")
                                .valido(valor as String);
                          },
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoEstado = valor as String;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoCategoria,
                          //hint: Text("Categorias"),
                          onSaved: (categoria) {
                            _anuncio.categoria = categoria as String;
                          },
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          items: _listaItensCategorias,
                          validator: (valor) {
                            return Validador()
                                .add(Validar.OBRIGATORIO,
                                    msg: "Campo obrigatório")
                                .valido(valor as String);
                          },
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoCategoria = valor as String;
                            });
                            print(
                                "Categoria selecionada: $_itemSelecionadoCategoria");
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 15),
                  child: InputCustomizado(
                    "Título",
                    Icon(
                      Icons.text_fields,
                      color: Colors.black,
                    ),
                    controller: _controllerTitulo,
                    onSaved: (titulo) {
                      _anuncio.titulo = titulo!;
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .minLength(3, msg: "Informe pelo menos 3 caracteres")
                          .valido(valor as String);
                    },
                    inputFormaters: [
                      FilteringTextInputFormatter(
                          RegExp("[a-z A-Z á-ú Á-Ú 0-9]"),
                          allow: true)
                    ],
                    letras: TextCapitalization.sentences,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: InputCustomizado(
                    "Preço",
                    Icon(
                      Icons.attach_money_rounded,
                      color: Colors.black,
                    ),
                    controller: _controllerPreco,
                    type: TextInputType.number,
                    onSaved: (preco) {
                      _anuncio.preco = preco.toString();
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .valido(valor as String);
                    },
                    inputFormaters: [
                      FilteringTextInputFormatter.digitsOnly,
                      RealInputFormatter(centavos: true)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: InputCustomizado(
                    "Telefone",
                    Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    controller: _controllerTelefone,
                    type: TextInputType.phone,
                    onSaved: (tel) {
                      _anuncio.telefone = tel.toString();
                    },
                    validator: (valor) {
                      String telefone = valor!.replaceAll("(", "");
                      telefone = telefone.replaceAll(")", "");
                      telefone = telefone.replaceAll("-", "");
                      telefone = telefone.replaceAll(" ", "");
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .minLength(10,
                              msg: "Informe o DDD + o número do celular")
                          .maxLength(11,
                              msg: "Informe apenas o DDD + o número do celular")
                          .valido(telefone);
                    },
                    inputFormaters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter()
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: InputCustomizado(
                    "Descrição",
                    Icon(
                      Icons.text_fields_sharp,
                      color: Colors.black,
                    ),
                    controller: _controllerDescricao,
                    onSaved: (descricao) {
                      _anuncio.descricao = descricao!;
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                          .maxLength(200, msg: "Máximo de 200 caracteres")
                          .valido(valor as String);
                    },
                    maxLinhas: 5,
                    inputFormaters: [
                      FilteringTextInputFormatter(
                          RegExp("[a-z A-Z á-ú Á-Ú 0-9]"),
                          allow: true)
                    ],
                    textoAjuda: "Digite apenas letras e números",
                  ),
                ),
                _status
                    ? TextButton(
                        onPressed: () {},
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      )
                    : BotaoCustomizado(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!
                                .save(); //Vai chamar o método onSaved
                            _salvarAnuncio();
                          }
                        },
                        texto: "Cadastrar anúncio",
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
