import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/anuncio.dart';
import '../models/produto.dart';

class ApiService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Map<String, dynamic>>> fetchAnunciosWithProdutos() async {
    final anunciosResponse = await http.get(Uri.parse('$baseUrl/anuncios'));
    final produtosResponse = await http.get(Uri.parse('$baseUrl/produtos'));

    if (anunciosResponse.statusCode == 200 && produtosResponse.statusCode == 200) {
      List<dynamic> anunciosData = json.decode(anunciosResponse.body);
      List<dynamic> produtosData = json.decode(produtosResponse.body);

      Map<String, Produto> produtosMap = {
        for (var item in produtosData)
          item['id'].toString(): Produto.fromJson(item)
      };

      return anunciosData.map((anuncioJson) {
        final produtoId = anuncioJson['produtoId'].toString();
        final produto = produtosMap[produtoId];
        return {
          'anuncio': Anuncio.fromJson(anuncioJson),
          'produto': produto,
        };
      }).toList();
    } else {
      throw Exception('Erro ao carregar anúncios e produtos');
    }
  }

  Future<String> addProduto(Produto produto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/produtos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': produto.nome,
        'foto': produto.foto,
        'descricao': produto.descricao,
      }),
    );
    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return responseData['id'];
    } else {
      throw Exception('Erro ao adicionar produto');
    }
  }

  Future<void> addAnuncio(Anuncio anuncio) async {
    final response = await http.post(
      Uri.parse('$baseUrl/anuncios'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'produtoId': anuncio.produtoId,
        'preco': anuncio.preco,
        'tamanho': anuncio.tamanho,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Erro ao adicionar anúncio');
    }
  }
}