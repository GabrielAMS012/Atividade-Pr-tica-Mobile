import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/anuncio_list_screen.dart';
import 'screens/anuncio_form_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicação de Venda de Moda',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/anuncios': (context) => AnuncioListScreen(),
        '/novo_anuncio': (context) => AnuncioFormScreen(),
      },
    );
  }
}
