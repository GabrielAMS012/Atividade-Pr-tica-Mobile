import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bem-vindo à Loja de Moda'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/anuncios');
              },
              child: Text('Ver Anúncios'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/novo_anuncio');
              },
              child: Text('Novo Anúncio'),
            ),
          ],
        ),
      ),
    );
  }
}
