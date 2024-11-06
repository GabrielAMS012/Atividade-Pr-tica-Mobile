class Produto {
  final String id;
  final String nome;
  final String foto;
  final String descricao;

  Produto({
    required this.id,
    required this.nome,
    required this.foto,
    required this.descricao,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'].toString(),
      nome: json['nome'],
      foto: json['foto'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'foto': foto,
      'descricao': descricao,
    };
  }
}
