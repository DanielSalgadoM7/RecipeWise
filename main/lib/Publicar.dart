import 'package:flutter/material.dart';
import 'PreviewReceita.dart'; // Certifique-se de usar o caminho correto

class Publicar extends StatefulWidget {
  @override
  _PublicarState createState() => _PublicarState();
}

class _PublicarState extends State<Publicar> {
  final String assetPath = 'assets/images/tortafrango.jpg'; // Caminho da imagem de assets

  void _mostrarPreview() {
    // Navega para a tela de preview com a imagem de asset
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PreviewReceita(assetPath: assetPath), // Passando o assetPath
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Publicar receitas")),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red, // Cor de fundo do botão
            foregroundColor: Colors.white, // Cor do texto do botão
          ),
          onPressed: _mostrarPreview, // Chama a função para mostrar o preview
          child: Text("Tirar Foto da Receita"),
        ),
      ),
    );
  }
}