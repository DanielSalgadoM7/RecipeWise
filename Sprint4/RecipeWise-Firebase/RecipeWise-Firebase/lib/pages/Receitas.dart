import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:main/pages/ReceitasTelas/DetalhesReceita.dart';

class Receitas extends StatefulWidget {
  final bool fromPrimeiraTela;
  final String textoPesquisado; // Novo parâmetro

  const Receitas({
    super.key,
    this.fromPrimeiraTela = false,
    this.textoPesquisado = '', // Valor padrão
  });

  @override
  _ReceitasState createState() => _ReceitasState();
}

class _ReceitasState extends State<Receitas> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _todasReceitas = [];
  List<Map<String, dynamic>> _receitasFiltradas = [];

  @override
  void initState() {
    super.initState();
    _carregarReceitas();
    _searchController.text = widget.textoPesquisado; // Inicializa com o texto pesquisado
    _searchController.addListener(() {
      _filtrarReceitas(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _carregarReceitas() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('receitas').get();
      setState(() {
        _todasReceitas = snapshot.docs.map((doc) => {
          ...doc.data(),
          'id': doc.id,
        }).toList();
        _filtrarReceitas(widget.textoPesquisado); // Aplica o filtro inicial
      });
    } catch (e) {
      print('Erro ao carregar receitas: $e');
    }
  }

  void _filtrarReceitas(String query) {
    setState(() {
      _receitasFiltradas = _todasReceitas.where((receita) {
        final nomeReceita = receita['nomeReceita']?.toString().toLowerCase() ?? '';
        final ingredientes = receita['ingredientes'] as List?;
        final ingredientesString = ingredientes != null
            ? ingredientes.map((ing) => ing['nome']?.toString().toLowerCase()).join(' ')
            : '';

        return nomeReceita.contains(query.toLowerCase()) ||
            ingredientesString.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromPrimeiraTela) {
          Navigator.pop(context);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Receitas"),
          leading: widget.fromPrimeiraTela
              ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )
              : null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Barra de pesquisa
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Pesquisar...",
                          icon: Icon(Icons.search, color: Colors.red),
                        ),
                        style: const TextStyle(fontSize: 18),
                        controller: _searchController,
                      ),
                    ),
                    // Botão de exclusão
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          _searchController.clear();
                          _filtrarReceitas('');
                        },
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _receitasFiltradas.isEmpty
                    ? const Center(child: Text('Nenhuma receita encontrada.'))
                    : ListView.builder(
                  itemCount: _receitasFiltradas.length,
                  itemBuilder: (context, index) {
                    final receita = _receitasFiltradas[index];
                    return _buildReceitaCard(
                      receita['nomeReceita'] ?? 'Sem Título',
                      receita['modoPreparo'] ?? 'Sem Descrição',
                      receita['tempoPreparo'] ?? 'Sem Tempo',
                      receita['imagemUrl'] ?? 'assets/images/escondidinho.jpg',
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalhesReceita(
                              titulo: receita['nomeReceita'] ?? 'Sem Título',
                              ingredientes:
                              _formatIngredientes(receita['ingredientes']),
                              modoPreparo:
                              receita['modoPreparo'] ?? 'Sem Modo de Preparo',
                              imagem: receita['imagemUrl'] ??
                                  'assets/images/escondidinho.jpg',
                              linkTutorial: receita['linkTutorial'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para formatar ingredientes
  String _formatIngredientes(dynamic ingredientes) {
    if (ingredientes is List) {
      return ingredientes.map((ing) {
        return "${ing['quantidade'] ?? ''} ${ing['unidade'] ?? ''} ${ing['nome'] ?? ''}".trim();
      }).join('\n');
    }
    return 'Sem Ingredientes';
  }

  // Função para criar os cards de receita
  Widget _buildReceitaCard(String titulo, String descricao, String tempo,
      String imagem, VoidCallback onTap) {
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
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        margin: const EdgeInsets.symmetric(vertical: 10),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: imagem.startsWith('assets/')
                    ? Image.asset(
                  imagem,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                )
                    : Image.network(
                  imagem,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/escondidinho.jpg',
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      descricao,
                      style: TextStyle(
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 16, color: Colors.red),
                        const SizedBox(width: 5),
                        Text(
                          tempo,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
