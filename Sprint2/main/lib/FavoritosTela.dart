// FavoritosTela.dart
import 'package:flutter/material.dart';

class Favoritos extends StatelessWidget {
  final String texto;
  Favoritos(this.texto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favoritos")),
      body: Center(child: Text(texto)),
    );
  }
}