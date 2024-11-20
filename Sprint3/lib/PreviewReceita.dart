import 'package:flutter/material.dart';
import 'dart:io';

class PreviewReceita extends StatefulWidget {
  final File imageFile; // Propriedade para o arquivo de imagem

  PreviewReceita({required this.imageFile});

  @override
  _PreviewReceitaState createState() => _PreviewReceitaState();
}

class _PreviewReceitaState extends State<PreviewReceita> {
  double _buttonScale = 1.0;

  void _onButtonPress() {
    setState(() {
      _buttonScale = 0.9;
    });
  }

  void _onButtonRelease() {
    setState(() {
      _buttonScale = 1.0;
    });

    // Lógica para salvar a receita aqui
    print("Receita visualizada com a imagem.");

    Navigator.pop(context); // Volta para a tela anterior
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Preview da Receita")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibe a imagem capturada
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 4.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.file(widget.imageFile), // Exibe o arquivo de imagem
              ),
            ),
            SizedBox(height: 20),
            // Campos de texto para detalhes da receita
            TextField(
              decoration: InputDecoration(labelText: "Nome"),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Ingredientes"),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Preparo"),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Tempo"),
            ),
            TextField(
              decoration: InputDecoration(labelText: "Dificuldade"),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTapDown: (_) => _onButtonPress(),
              onTapUp: (_) => _onButtonRelease(),
              onTapCancel: () => _onButtonRelease(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                transform: Matrix4.identity()..scale(_buttonScale),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Text(
                    "Publicar Receita",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
