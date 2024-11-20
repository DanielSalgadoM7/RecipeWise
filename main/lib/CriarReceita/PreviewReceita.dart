import 'package:flutter/material.dart';
import 'dart:io';

class PreviewReceita extends StatefulWidget {
  final File imageFile;

  PreviewReceita({required this.imageFile});

  @override
  _PreviewReceitaState createState() => _PreviewReceitaState();
}

class _PreviewReceitaState extends State<PreviewReceita> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  // Variáveis para armazenar os dados
  String _nomeReceita = "";
  List<Map<String, dynamic>> _ingredientes = [];
  String _modoPreparo = "";
  TimeOfDay _tempoPreparo = TimeOfDay(hour: 0, minute: 0);
  String _dificuldade = "Fácil";

  // Funções de controle
  void _proximaPagina() {
    if (_currentPage < 4) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _paginaAnterior() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Receita"),
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          // Etapa 1: Nome da Receita
          _buildNomeReceita(),
          // Etapa 2: Ingredientes
          _buildIngredientes(),
          // Etapa 3: Modo de Preparo
          _buildModoPreparo(),
          // Etapa 4: Tempo e Dificuldade
          _buildTempoEDificuldade(),
          // Etapa 5: Resumo e Confirmação
          _buildResumo(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentPage > 0)
              TextButton(
                onPressed: _paginaAnterior,
                child: Text("Voltar"),
              ),
            TextButton(
              onPressed: _proximaPagina,
              child: Text(_currentPage == 4 ? "Finalizar" : "Próximo"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNomeReceita() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Etapa 1: Nome da Receita", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextField(
            decoration: InputDecoration(labelText: "Nome da Receita"),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Etapa 2: Ingredientes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ..._ingredientes.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> ingrediente = entry.value;
            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    decoration: InputDecoration(labelText: "Ingrediente"),
                    onChanged: (value) => _ingredientes[index]["nome"] = value,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(labelText: "Qtd"),
                    keyboardType: TextInputType.number,
                    onChanged: (value) => _ingredientes[index]["quantidade"] = value,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: InputDecoration(labelText: "Unidade"),
                    onChanged: (value) => _ingredientes[index]["unidade"] = value,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removerIngrediente(index),
                ),
              ],
            );
          }),
          ElevatedButton(
            onPressed: _adicionarIngrediente,
            child: Text("Adicionar Ingrediente"),
          ),
        ],
      ),
    );
  }

  Widget _buildModoPreparo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Etapa 3: Modo de Preparo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextField(
            maxLines: 5,
            decoration: InputDecoration(labelText: "Descreva o modo de preparo"),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Etapa 4: Tempo e Dificuldade", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text("Tempo de Preparo: ${_tempoPreparo.hour}h ${_tempoPreparo.minute}min"),
              IconButton(
                icon: Icon(Icons.access_time),
                onPressed: _selecionarTempo,
              ),
            ],
          ),
          DropdownButton<String>(
            value: _dificuldade,
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
        ],
      ),
    );
  }

  Widget _buildResumo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Resumo da Receita", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text("Nome: $_nomeReceita"),
          Text("Ingredientes: $_ingredientes"),
          Text("Modo de Preparo: $_modoPreparo"),
          Text("Tempo: ${_tempoPreparo.hour}h ${_tempoPreparo.minute}min"),
          Text("Dificuldade: $_dificuldade"),
        ],
      ),
    );
  }
}
