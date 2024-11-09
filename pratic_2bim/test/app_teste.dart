import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';
import 'package:pratic_2bim/models/produto.dart';
import 'package:pratic_2bim/models/anuncio.dart';
import 'package:pratic_2bim/services/api_service.dart';
import 'package:pratic_2bim/screens/anuncio_list_screen.dart';

@GenerateMocks([http.Client, ApiService])
import 'app_teste.mocks.dart';

void main() {
  group('Testes Unitários', () {
    test('Deve converter JSON para Produto corretamente', () {
      final json = {
        'id': '1',
        'nome': 'Camiseta Básica',
        'foto': 'https://example.com/camiseta.jpg',
        'descricao': 'Camiseta de algodão, disponível em várias cores.',
      };

      final produto = Produto.fromJson(json);

      expect(produto.id, '1');
      expect(produto.nome, 'Camiseta Básica');
      expect(produto.foto, 'https://example.com/camiseta.jpg');
      expect(produto.descricao, 'Camiseta de algodão, disponível em várias cores.');
    });

    test('Deve converter JSON para Anuncio corretamente', () {
      final json = {
        'id': '1',
        'produtoId': '1',
        'preco': 49.99,
        'tamanho': 'M',
      };

      final anuncio = Anuncio.fromJson(json);

      expect(anuncio.id, '1');
      expect(anuncio.produtoId, '1');
      expect(anuncio.preco, 49.99);
      expect(anuncio.tamanho, 'M');
    });
  });

  group('Teste com Mock HTTP', () {
    test('Deve filtrar anúncios com preço acima de 50', () async {
      final client = MockClient();
      final apiService = ApiService(client: client);

      when(client.get(Uri.parse('http://localhost:3000/anuncios')))
          .thenAnswer((_) async => http.Response(json.encode([
        {'id': '1', 'produtoId': '1', 'preco': 60, 'tamanho': 'M'},
        {'id': '2', 'produtoId': '2', 'preco': 45, 'tamanho': 'G'},
      ]), 200));

      when(client.get(Uri.parse('http://localhost:3000/produtos')))
          .thenAnswer((_) async => http.Response(json.encode([
        {'id': '1', 'nome': 'Produto 1', 'foto': '', 'descricao': ''},
        {'id': '2', 'nome': 'Produto 2', 'foto': '', 'descricao': ''},
      ]), 200));

      final anuncios = await apiService.fetchAnunciosWithProdutos();

      final filteredAnuncios =
      anuncios.where((anuncio) => anuncio['anuncio'].preco > 50).toList();

      expect(filteredAnuncios.length, 1);
      expect(filteredAnuncios[0]['anuncio'].preco, 60);
    });
  });

  group('Teste de Widget', () {
    testWidgets('Deve exibir lista de anúncios', (WidgetTester tester) async {
      final mockApiService = MockApiService();

      when(mockApiService.fetchAnunciosWithProdutos()).thenAnswer((_) async => [
        {
          'anuncio': Anuncio(id: '1', produtoId: '1', preco: 60.0, tamanho: 'M'),
          'produto': Produto(id: '1', nome: 'Produto 1', foto: '', descricao: ''),
        },
      ]);

      await tester.pumpWidget(
        Provider<ApiService>.value(
          value: mockApiService,
          child: MaterialApp(home: AnuncioListScreen()),
        ),
      );

      // Aguarda para que os dados carreguem corretamente
      await tester.pumpAndSettle();

      // Verifica se o widget exibe o conteúdo esperado
      expect(find.text('Produto 1'), findsOneWidget);
      expect(find.text('R\$ 60.0 - Tamanho: M'), findsOneWidget);
    });
  });
}
