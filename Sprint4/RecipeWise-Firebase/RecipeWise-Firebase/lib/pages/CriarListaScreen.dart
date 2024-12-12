import 'package:flutter/material.dart';
import '../services/SqlHelper/Lista_SQLHelper.dart';

class CriarListaScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onListaCriada;

  const CriarListaScreen({super.key, required this.onListaCriada});

  @override
  _CriarListaScreenState createState() => _CriarListaScreenState();
}

class _CriarListaScreenState extends State<CriarListaScreen> {
  final TextEditingController _nomeController = TextEditingController();
  int _corSelecionadaId = 0;

  final List<Color> coresDisponiveis = [
    const Color(0xFFF48FB1),
    const Color(0xFF90CAF9),
    const Color(0xFFA5D6A7),
    const Color(0xFFCE93D8),
    const Color(0xFFFFCC80),
  ];

  void _criarLista() async {
    if (_nomeController.text.isNotEmpty) {
      Map<String, dynamic> novaLista = {
        'nome': _nomeController.text,
        'cor': coresDisponiveis[_corSelecionadaId].value,
      };

      // Cria a nova lista no banco de dados
      await ListaSQLHelper.createLista(novaLista['nome'], novaLista['cor']);

      // Chama o callback para notificar que uma nova lista foi criada
      widget.onListaCriada(novaLista);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Nova Lista"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome da Lista'),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              children: List.generate(coresDisponiveis.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _corSelecionadaId = index;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: coresDisponiveis[index],
                    child: _corSelecionadaId == index
                        ? const Icon(Icons.check)
                        : null,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _criarLista,
              child: const Text("Criar Lista"),
            ),
          ],
        ),
      ),
    );
  }
}
