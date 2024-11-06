import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/anuncio.dart';
import '../models/produto.dart';

class AnuncioListScreen extends StatefulWidget {
  @override
  _AnuncioListScreenState createState() => _AnuncioListScreenState();
}

class _AnuncioListScreenState extends State<AnuncioListScreen> {
  late Future<List<Map<String, dynamic>>> anunciosWithProdutos;

  @override
  void initState() {
    super.initState();
    anunciosWithProdutos = ApiService().fetchAnunciosWithProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Anúncios')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: anunciosWithProdutos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum anúncio disponível'));
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final anuncioMap = snapshot.data![index];
                final anuncio = anuncioMap['anuncio'] as Anuncio;
                final produto = anuncioMap['produto'] as Produto;

                return ListTile(
                  title: Text(produto.nome),
                  subtitle: Text('R\$ ${anuncio.preco} - Tamanho: ${anuncio.tamanho}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
