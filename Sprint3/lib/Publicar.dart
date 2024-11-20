import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Necessário para trabalhar com arquivos de imagem
import 'PreviewReceita.dart';

class Publicar extends StatefulWidget {
  @override
  _PublicarState createState() => _PublicarState();
}

class _PublicarState extends State<Publicar> {
  File? _imageFile; // Arquivo de imagem que será armazenado

  Future<void> _capturarFoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Converte o caminho para File
      });

      // Navega para a tela de preview com a imagem capturada
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PreviewReceita(imageFile: _imageFile!), // Passando a imagem capturada
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Publicar receitas")),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: _capturarFoto, // Abre a câmera ao clicar
          child: Text("Tirar Foto da Receita"),
        ),
      ),
    );
  }
}
