// DicasTela.dart
import 'package:flutter/material.dart';

class Dicas extends StatelessWidget {
  final String texto;
  Dicas(this.texto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dicas")),
      body: Center(child: Text(texto)),
    );
  }
}