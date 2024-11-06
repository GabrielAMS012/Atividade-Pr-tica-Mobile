import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../models/anuncio.dart';
import '../services/api_service.dart';

class AnuncioFormScreen extends StatefulWidget {
  @override
  _AnuncioFormScreenState createState() => _AnuncioFormScreenState();
}

class _AnuncioFormScreenState extends State<AnuncioFormScreen> {
  final GlobalKey<FormState> _formKeyProduto = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyAnuncio = GlobalKey<FormState>();

  late String nomeProduto;
  late String foto;
  late String descricao;

  late double preco;
  late String tamanho;

  String? produtoId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Novo Anúncio')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
              key: _formKeyProduto,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Informações do Produto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Nome do Produto'),
                    onSaved: (value) => nomeProduto = value!,
                    validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Foto URL'),
                    onSaved: (value) => foto = value!,
                    validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Descrição'),
                    onSaved: (value) => descricao = value!,
                    validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKeyProduto.currentState!.validate()) {
                        _formKeyProduto.currentState!.save();
                        Produto novoProduto = Produto(id: "", nome: nomeProduto, foto: foto, descricao: descricao);
                        try {
                          produtoId = await ApiService().addProduto(novoProduto);
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Produto cadastrado com sucesso!'))
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erro ao cadastrar produto: $e'))
                          );
                        }
                      }
                    },
                    child: Text('Salvar Produto'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (produtoId != null)
              Form(
                key: _formKeyAnuncio,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Informações do Anúncio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Preço'),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => preco = double.parse(value!),
                      validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Tamanho'),
                      onSaved: (value) => tamanho = value!,
                      validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKeyAnuncio.currentState!.validate()) {
                          _formKeyAnuncio.currentState!.save();
                          Anuncio novoAnuncio = Anuncio(id: "", produtoId: produtoId!, preco: preco, tamanho: tamanho);
                          try {
                            await ApiService().addAnuncio(novoAnuncio);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Anúncio cadastrado com sucesso!'))
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Erro ao cadastrar anúncio: $e'))
                            );
                          }
                        }
                      },
                      child: Text('Salvar Anúncio'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
