import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreviewReceita extends StatefulWidget {
  final File imageFile;

  const PreviewReceita({super.key, required this.imageFile});

  @override
  _PreviewReceitaState createState() => _PreviewReceitaState();
}

class _PreviewReceitaState extends State<PreviewReceita> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  String _nomeReceita = "";
  final List<Map<String, dynamic>> _ingredientes = [];
  String _modoPreparo = "";
  TimeOfDay _tempoPreparo = const TimeOfDay(hour: 0, minute: 0);
  String _dificuldade = "Fácil";

  void _proximaPagina() async {
    if (_currentPage == 4) {
      try {
        await _salvarReceitaNoFirestore();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Receita cadastrada com sucesso!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao cadastrar receita: $e")),
        );
      }
    } else {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _paginaAnterior() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Future<void> _selecionarTempo() async {
    final TimeOfDay? novoTempo = await showTimePicker(
      context: context,
      initialTime: _tempoPreparo,
    );
    if (novoTempo != null) {
      setState(() {
        _tempoPreparo = novoTempo;
      });
    }
  }

  void _adicionarIngrediente() {
    setState(() {
      _ingredientes.add({"nome": "", "quantidade": "", "unidade": ""});
    });
  }

  void _removerIngrediente(int index) {
    setState(() {
      _ingredientes.removeAt(index);
    });
  }

  Future<void> _salvarReceitaNoFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final receita = {
      "nomeReceita": _nomeReceita,
      "ingredientes": _ingredientes,
      "modoPreparo": _modoPreparo,
      "tempoPreparo": "${_tempoPreparo.hour}h ${_tempoPreparo.minute}min",
      "dificuldade": _dificuldade,
      "dataCadastro": DateTime.now(),
    };

    await firestore.collection("receitas").add(receita);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nova Receita"),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildNomeReceita(),
          _buildIngredientes(),
          _buildModoPreparo(),
          _buildTempoEDificuldade(),
          _buildResumo(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_currentPage > 0)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _paginaAnterior,
                      child: const Text("Voltar"),
                    ),
                  ),
                ),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _proximaPagina,
                  child: Text(_currentPage == 4 ? "Finalizar" : "Próximo"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNomeReceita() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Etapa 1: Nome da Receita",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red[700]
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: "Nome da Receita",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            textAlign: TextAlign.center,
            onChanged: (value) => _nomeReceita = value,
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientes() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Etapa 2: Ingredientes",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red[700]
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                ..._ingredientes.asMap().entries.map((entry) {
                  int index = entry.key;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Ingrediente",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) => _ingredientes[index]["nome"] = value,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Qtd",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) =>
                            _ingredientes[index]["quantidade"] = value,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          flex: 2,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: "Unidade",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) =>
                            _ingredientes[index]["unidade"] = value,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removerIngrediente(index),
                        ),
                      ],
                    ),
                  );
                }),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: _adicionarIngrediente,
                    child: const Text("Adicionar Ingrediente"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModoPreparo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Etapa 3: Modo de Preparo",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red[700]
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          TextField(
            maxLines: 8,
            decoration: InputDecoration(
              labelText: "Descreva o modo de preparo",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            textAlign: TextAlign.center,
            onChanged: (value) => _modoPreparo = value,
          ),
        ],
      ),
    );
  }

  Widget _buildTempoEDificuldade() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Etapa 4: Tempo e Dificuldade",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red[700]
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tempo de Preparo: ${_tempoPreparo.hour}h ${_tempoPreparo.minute}min",
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.access_time, color: Colors.red),
                onPressed: _selecionarTempo,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: DropdownButton<String>(
              value: _dificuldade,
              hint: const Text("Selecione a Dificuldade"),
              items: ["Fácil", "Médio", "Difícil"]
                  .map((dificuldade) => DropdownMenuItem<String>(
                value: dificuldade,
                child: Text(dificuldade),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _dificuldade = value!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Resumo da Receita",
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red[700]
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildResumoItem("Nome", _nomeReceita),
                _buildResumoItem("Ingredientes", _formatIngredientes()),
                _buildResumoItem("Modo de Preparo", _modoPreparo),
                _buildResumoItem("Tempo", "${_tempoPreparo.hour}h ${_tempoPreparo.minute}min"),
                _buildResumoItem("Dificuldade", _dificuldade),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "$label:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red[700],
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatIngredientes() {
    return _ingredientes.map((ing) =>
    "${ing['quantidade']} ${ing['unidade']} de ${ing['nome']}"
    ).join(", ");
  }
}