import 'package:flutter/material.dart';

class PreviewReceita extends StatefulWidget {
  final String assetPath; // Propriedade para o caminho da imagem de asset

  // Construtor que aceita assetPath
  PreviewReceita({required this.assetPath});

  @override
  _PreviewReceitaState createState() => _PreviewReceitaState();
}

class _PreviewReceitaState extends State<PreviewReceita> {
  double _buttonScale = 1.0; // Para controlar o tamanho do botão

  void _onButtonPress() {
    setState(() {
      _buttonScale = 0.9; // Reduz o tamanho do botão ao pressionar
    });
  }

  void _onButtonRelease() {
    setState(() {
      _buttonScale = 1.0; // Restaura o tamanho do botão após soltar
    });
    // Lógica para salvar a receita aqui
    print("Receita visualizada com a imagem.");

    // Volta para a primeira tela
    Navigator.pop(context); // Volta para a tela anterior no stack de navegação
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
            // Aqui, estamos usando um Card com bordas arredondadas
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 4.0, // Sombra do card
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0), // Mesma borda arredondada
                child: Image.asset(widget.assetPath), // Exibe a imagem de asset
              ),
            ),
            SizedBox(height: 20),
            // Adicione campos de texto ou outros widgets conforme necessário
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
                duration: Duration(milliseconds: 100), // Duração da animação
                curve: Curves.easeInOut, // Curva da animação
                transform: Matrix4.identity()..scale(_buttonScale), // Aplica a escala
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                  decoration: BoxDecoration(
                    color: Colors.red, // Cor de fundo do botão
                    borderRadius: BorderRadius.circular(8.0), // Bordas arredondadas
                  ),
                  child: Text(
                    "Publicar Receita",
                    style: TextStyle(
                      color: Colors.white, // Cor do texto
                      fontSize: 18.0, // Tamanho da fonte
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
