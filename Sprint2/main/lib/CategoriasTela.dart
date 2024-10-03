// CategoriasTela.dart
import 'package:flutter/material.dart';

class Categorias extends StatelessWidget {
  final String texto;
  Categorias(this.texto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categorias")),
      body: Center(child: Text(texto)),
    );
  }
}