import 'package:flutter/material.dart';
import '../screens/anuncio_form_screen.dart';
import '../services/api_service.dart';
import '../models/anuncio.dart';
import '../models/produto.dart';
import '../components/anuncio_card.dart';

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

  Future<void> _refreshAnuncios() async {
    setState(() {
      anunciosWithProdutos = ApiService().fetchAnunciosWithProdutos();
    });
  }

  Future<void> _deleteAnuncio(String anuncioId, String produtoId) async {
    try {
      await ApiService().deleteAnuncio(anuncioId, produtoId);
      _refreshAnuncios();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anúncio deletado com sucesso')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar anúncio: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFAF0E6),
      appBar: AppBar(
        backgroundColor: Color(0xFF352F44),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Anúncios',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8,
                ),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final anuncioMap = snapshot.data![index];
                  final anuncio = anuncioMap['anuncio'] as Anuncio;
                  final produto = anuncioMap['produto'] as Produto;

                  return AnuncioCard(
                    anuncio: anuncio,
                    produto: produto,
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnuncioFormScreen(
                            anuncio: anuncio,
                            produto: produto,
                          ),
                        ),
                      ).then((_) => _refreshAnuncios());
                    },
                    onDelete: () => _deleteAnuncio(anuncio.id, produto.id),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
