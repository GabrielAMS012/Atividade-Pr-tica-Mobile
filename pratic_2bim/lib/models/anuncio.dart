class Anuncio {
  final String id;
  final String produtoId;
  final double preco;
  final String tamanho;

  Anuncio({
    required this.id,
    required this.produtoId,
    required this.preco,
    required this.tamanho,
  });

  factory Anuncio.fromJson(Map<String, dynamic> json) {
    return Anuncio(
      id: json['id'].toString(),
      produtoId: json['produtoId'].toString(),
      preco: json['preco'].toDouble(),
      tamanho: json['tamanho'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'produtoId': produtoId,
      'preco': preco,
      'tamanho': tamanho,
    };
  }
}
