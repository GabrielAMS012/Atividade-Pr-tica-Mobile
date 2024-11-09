import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/anuncio.dart';
import '../models/produto.dart';

class ApiService {
  final String baseUrl = 'http://localhost:3000';
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Map<String, dynamic>>> fetchAnunciosWithProdutos() async {
    final anunciosResponse = await client.get(Uri.parse('$baseUrl/anuncios'));
    final produtosResponse = await client.get(Uri.parse('$baseUrl/produtos'));

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

  Future<Produto> addProduto(Produto produto) async {
    try {
      final response = await client.post(
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
        return Produto(
          id: responseData['id'].toString(),
          nome: produto.nome,
          foto: produto.foto,
          descricao: produto.descricao,
        );
      } else {
        throw Exception('Erro ao adicionar produto');
      }
    } catch (e) {
      throw Exception('Erro de rede ao adicionar produto: $e');
    }
  }

  Future<void> addAnuncio(Anuncio anuncio) async {
    try {
      final response = await client.post(
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
    } catch (e) {
      throw Exception('Erro de rede ao adicionar anúncio: $e');
    }
  }

  Future<void> updateProduto(Produto produto) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/produtos/${produto.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': produto.nome,
          'foto': produto.foto,
          'descricao': produto.descricao,
        }),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao atualizar produto');
      }
    } catch (e) {
      throw Exception('Erro de rede ao atualizar produto: $e');
    }
  }

  Future<void> updateAnuncio(Anuncio anuncio) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/anuncios/${anuncio.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'produtoId': anuncio.produtoId,
          'preco': anuncio.preco,
          'tamanho': anuncio.tamanho,
        }),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Erro ao atualizar anúncio');
      }
    } catch (e) {
      throw Exception('Erro de rede ao atualizar anúncio: $e');
    }
  }

  Future<void> deleteAnuncio(String anuncioId, String produtoId) async {
    final anuncioResponse = await client.delete(Uri.parse('$baseUrl/anuncios/$anuncioId'));
    final produtoResponse = await client.delete(Uri.parse('$baseUrl/produtos/$produtoId'));

    if (anuncioResponse.statusCode != 200 && anuncioResponse.statusCode != 204) {
      throw Exception('Erro ao deletar anúncio');
    }

    if (produtoResponse.statusCode != 200 && produtoResponse.statusCode != 204) {
      throw Exception('Erro ao deletar produto associado');
    }
  }
}
