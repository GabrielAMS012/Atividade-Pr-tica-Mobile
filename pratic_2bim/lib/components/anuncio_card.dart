import 'package:flutter/material.dart';
import '../models/anuncio.dart';
import '../models/produto.dart';

class AnuncioCard extends StatelessWidget {
  final Anuncio anuncio;
  final Produto produto;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AnuncioCard({
    Key? key,
    required this.anuncio,
    required this.produto,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: produto.foto.isNotEmpty
                      ? Image.network(
                    produto.foto,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.broken_image, color: Color(0xFF5C5470));
                    },
                  )
                      : Icon(Icons.image, color: Color(0xFF5C5470), size: 50),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      produto.nome,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF352F44),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'R\$ ${anuncio.preco.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Color(0xFF5C5470),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            icon: Icon(Icons.edit, color: Color(0xFF5C5470)),
            onPressed: onEdit,
          ),
        ),
        Positioned(
          top: 8,
          left: 8,
          child: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }
}
