import 'package:flutter/material.dart';
import '../models/produto.dart';
import '../models/anuncio.dart';
import '../services/api_service.dart';

class AnuncioFormScreen extends StatefulWidget {
  final Anuncio? anuncio; // Parâmetro opcional para anúncio existente
  final Produto? produto; // Parâmetro opcional para produto existente

  AnuncioFormScreen({this.anuncio, this.produto});

  @override
  _AnuncioFormScreenState createState() => _AnuncioFormScreenState();
}

class _AnuncioFormScreenState extends State<AnuncioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeProdutoController = TextEditingController();
  final _fotoProdutoController = TextEditingController();
  final _descricaoProdutoController = TextEditingController();
  final _precoController = TextEditingController();
  final _tamanhoController = TextEditingController();
  String? produtoId;

  @override
  void initState() {
    super.initState();
    if (widget.produto != null) {
      _nomeProdutoController.text = widget.produto!.nome;
      _fotoProdutoController.text = widget.produto!.foto;
      _descricaoProdutoController.text = widget.produto!.descricao;
      produtoId = widget.produto!.id;
    }
    if (widget.anuncio != null) {
      _precoController.text = widget.anuncio!.preco.toString();
      _tamanhoController.text = widget.anuncio!.tamanho;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final produto = Produto(
        id: produtoId ?? '', // Usando o ID existente para edição
        nome: _nomeProdutoController.text,
        foto: _fotoProdutoController.text,
        descricao: _descricaoProdutoController.text,
      );

      if (produtoId == null) {
        final createdProduto = await ApiService().addProduto(produto);
        produtoId = createdProduto.id;
      } else {
        await ApiService().updateProduto(produto); // Chamada PUT para atualizar
      }

      final anuncio = Anuncio(
        id: widget.anuncio?.id ?? '', // ID existente para edição
        produtoId: produtoId!,
        preco: double.parse(_precoController.text),
        tamanho: _tamanhoController.text,
      );

      if (widget.anuncio == null) {
        await ApiService().addAnuncio(anuncio);
      } else {
        await ApiService().updateAnuncio(anuncio); // Chamada PUT para atualizar
      }

      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _nomeProdutoController.dispose();
    _fotoProdutoController.dispose();
    _descricaoProdutoController.dispose();
    _precoController.dispose();
    _tamanhoController.dispose();
    super.dispose();
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
          widget.anuncio == null ? 'Novo Anúncio' : 'Editar Anúncio',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeProdutoController,
                decoration: _inputDecoration('Nome do Produto'),
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                validator: (value) => value!.isEmpty ? 'Este campo é obrigatório' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _fotoProdutoController,
                decoration: _inputDecoration('URL da Foto do Produto'),
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                validator: (value) => value!.isEmpty ? 'Este campo é obrigatório' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descricaoProdutoController,
                decoration: _inputDecoration('Descrição do Produto'),
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                validator: (value) => value!.isEmpty ? 'Este campo é obrigatório' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _precoController,
                decoration: _inputDecoration('Preço'),
                keyboardType: TextInputType.number,
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                validator: (value) => value!.isEmpty ? 'Este campo é obrigatório' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _tamanhoController,
                decoration: _inputDecoration('Tamanho'),
                style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
                validator: (value) => value!.isEmpty ? 'Este campo é obrigatório' : null,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5C5470),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: Text(
                    widget.anuncio == null ? 'Salvar Anúncio' : 'Atualizar Anúncio',
                    style: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Color(0xFF5C5470)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF5C5470)),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
