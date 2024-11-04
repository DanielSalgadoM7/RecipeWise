import 'package:flutter/material.dart';
import 'SqlHelper/Lista_SQLHelper.dart'; // Importe seu SQLHelper

class CriarListaScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onListaCriada;

  CriarListaScreen({required this.onListaCriada});

  @override
  _CriarListaScreenState createState() => _CriarListaScreenState();
}

class _CriarListaScreenState extends State<CriarListaScreen> {
  TextEditingController _nomeController = TextEditingController();
  int _corSelecionadaId = 0; // ID da cor selecionada

  // Mapeamento das cores com seus IDs
  final List<Color> coresDisponiveis = [
    Color(0xFFF48FB1),
    Color(0xFF90CAF9),
    Color(0xFFA5D6A7),
    Color(0xFFCE93D8),
    Color(0xFFFFCC80),
  ];

  void _criarLista() async {
    if (_nomeController.text.isNotEmpty) {
      Map<String, dynamic> novaLista = {
        'nome': _nomeController.text,
        'corId': _corSelecionadaId, // Armazenar o ID da cor
      };

      // Insira a nova lista no banco de dados
      await ListaSQLHelper().createLista(novaLista['nome'], novaLista['corId']);

      // Chama o callback para notificar que uma nova lista foi criada
      widget.onListaCriada(novaLista);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Criar Nova Lista"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome da Lista'),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 10,
              children: List.generate(coresDisponiveis.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _corSelecionadaId = index; // Altera o ID da cor selecionada
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: coresDisponiveis[index],
                    child: _corSelecionadaId == index ? Icon(Icons.check) : null,
                  ),
                );
              }),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _criarLista,
              child: Text("Criar Lista"),
            ),
          ],
        ),
      ),
    );
  }
}
