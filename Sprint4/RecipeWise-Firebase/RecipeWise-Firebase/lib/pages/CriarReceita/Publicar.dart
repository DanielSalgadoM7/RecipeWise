import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'PreviewReceita.dart';

class Publicar extends StatefulWidget {
  const Publicar({super.key});

  @override
  _PublicarState createState() => _PublicarState();
}

class _PublicarState extends State<Publicar> {
  File? _imageFile;
  Uint8List? _imageBytes;

  Future<void> _capturarFotoOuGaleria() async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Tirar Foto"),
                onTap: () async {
                  final pickedFile =
                  await picker.pickImage(source: ImageSource.camera);
                  Navigator.pop(context);
                  _processarImagem(pickedFile);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Escolher da Galeria"),
                onTap: () async {
                  final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context);
                  _processarImagem(pickedFile);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _processarImagem(XFile? pickedFile) async {
    if (pickedFile != null) {
      // Read image bytes
      final imageBytes = await pickedFile.readAsBytes();

      setState(() {
        _imageFile = File(pickedFile.path);
        _imageBytes = imageBytes;
      });

      // Show the image before navigating to preview
      _mostrarImagemSelecionada();
    }
  }

  void _mostrarImagemSelecionada() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Imagem Selecionada'),
          content: _imageBytes != null
              ? Image.memory(
            _imageBytes!,
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          )
              : const Text('Nenhuma imagem selecionada'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _imageFile = null;
                  _imageBytes = null;
                });
              },
            ),
            TextButton(
              child: const Text('Continuar'),
              onPressed: () {
                Navigator.of(context).pop();
                // Navigate to preview screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviewReceita(
                      imageFile: _imageFile!,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Publicar receitas")),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          onPressed: _capturarFotoOuGaleria,
          child: const Text("Adicionar Receita"),
        ),
      ),
    );
  }
}