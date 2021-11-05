class Usuario{

  late String id;
  late String nome;
  late String email;
  late String senha;
  
  Usuario();

  Map<String, dynamic> toMap(){
    Map<String,dynamic> map = {
      "id"    :this.id,
      //"nome"  :this.nome,
      "email" :this.email
    };
    return map;
  }
}