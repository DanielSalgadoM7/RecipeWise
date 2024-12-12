import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Para abrir links externos

class DetalhesReceita extends StatelessWidget {
  final String titulo;
  final String ingredientes;
  final String modoPreparo;
  String imagem;
  final String? linkTutorial; // Link opcional para tutorial

  DetalhesReceita({
    super.key,
    required this.titulo,
    required this.ingredientes,
    required this.modoPreparo,
    required this.imagem,
    this.linkTutorial,
  }) {
    // Lógica para substituir a imagem com base no título
    if (titulo.toLowerCase().startsWith('pizza')) {
      imagem = 'assets/images/pizza.jpg';
    }
    if (titulo.toLowerCase().startsWith('bolo')) {
      imagem = 'assets/images/bolo_de_cenoura.jpg';
    }
    if (titulo.toLowerCase().startsWith('macarronada')) {
      imagem = 'assets/images/macarrao_premium.jpg';
    }
    if (titulo.toLowerCase().startsWith('bife')) {
      imagem = 'assets/images/bife_fritas.jpg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titulo,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.red.shade800,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem da receita
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imagem,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Título da receita
              Center(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),

              // Ingredientes
              const Text(
                '🍅 Ingredientes:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  ingredientes,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Modo de preparo
              const Text(
                '🍳 Modo de Preparo:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  modoPreparo,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Botão para o tutorial em vídeo
              if (linkTutorial != null)
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (await canLaunch(linkTutorial!)) {
                        await launch(linkTutorial!);
                      } else {
                        throw 'Não foi possível abrir o link: $linkTutorial';
                      }
                    },
                    icon: const Icon(Icons.play_circle_fill),
                    label: const Text(
                      'Assista ao Tutorial',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
