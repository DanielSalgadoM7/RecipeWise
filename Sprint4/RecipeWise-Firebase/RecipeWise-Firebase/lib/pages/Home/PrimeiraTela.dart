import 'package:flutter/material.dart';
import '../../main.dart';
import '../Lista.dart';
import '../TelaBusca.dart';
import '../login/TelaBloqueio.dart';
import '../Receitas.dart';
import '../DicasTela.dart';
import '../CategoriasTela.dart';
import '../../services/SqlHelper/Lista_SqlHelper.dart'; // Importando o helper do banco de dados

int _paginaAtual = 0; // Controla a tela exibida

class PrimeiraTela extends StatefulWidget {
  const PrimeiraTela({super.key});

  @override
  _PrimeiraTelaState createState() => _PrimeiraTelaState();
}

class _PrimeiraTelaState extends State<PrimeiraTela> {
  final TextEditingController _textEditingController = TextEditingController();
  final List<String> _ultimasReceitas = [];
  List<Map<String, dynamic>> listas = [];

  @override
  void initState() {
    super.initState();
    _carregarListas(); // Carrega as listas ao iniciar a tela
  }

  Future<void> _carregarListas() async {
    final data = await ListaSQLHelper.getListas(); // Recupera as listas do banco
    setState(() {
      listas = data;
    });
  }

  Widget _buildIconButton(IconData icon, String label, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(icon, size: 24, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  void _removeTextoBusca() {
    setState(() {
      _textEditingController.clear();
    });
  }



  void _navegarParaReceitas() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Receitas()),
    );
  }

  void _navegarParaDicas() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Dicas("Tela de Dicas")),
    );
  }

  void _navegarParaCategorias() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Categorias("Tela de Categorias")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Barra de pesquisa
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildSearchButton(),
              const SizedBox(height: 20),
              _buildNavigationButtons(),
              const SizedBox(height: 20),
              _buildUltimasReceitasSection(),
              const SizedBox(height: 20),
              _buildPreviaDasListasSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Pesquisar...",
                prefixIcon: Icon(Icons.search, color: Colors.red),
              ),
              style: const TextStyle(fontSize: 18),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Receitas(textoPesquisado: value),
                    ),
                  );
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: _removeTextoBusca,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      child: const Text("BUSCAR"),
      onPressed: () {
        if (_textEditingController.text.isNotEmpty) {
          setState(() {
            _ultimasReceitas.add(_textEditingController.text);
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Receitas(textoPesquisado: _textEditingController.text),
            ),
          );
        }
      },
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconButton(Icons.receipt, "Receitas", _navegarParaReceitas),
        _buildIconButton(Icons.lightbulb, "Dicas", _navegarParaDicas),
        _buildIconButton(Icons.category, "Categorias", _navegarParaCategorias),
      ],
    );
  }

  Widget _buildUltimasReceitasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Últimas receitas pesquisadas:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _ultimasReceitas.isEmpty
            ? const Text("Nenhuma receita pesquisada ainda.")
            : Column(
          children: _ultimasReceitas.take(3).map((receita) {
            return ListTile(
              title: Text(receita),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeReceita(receita),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SegundaTela(valor: receita),
                  ),
                );
              },
            );
          }).toList(),
        ),
        if (_ultimasReceitas.length > 3)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text("+", style: TextStyle(fontSize: 20, color: Colors.red)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerTodasReceitas(_ultimasReceitas),
                    ),
                  );
                },
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildPreviaDasListasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Prévia das listas:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (listas.isEmpty)
          const Center(
            child: Text(
              "Nenhuma lista disponível.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 150,
              child: ListView.builder(
                itemCount: listas.length,
                itemBuilder: (context, index) {
                  final list = listas[index];
                  final String nomeLista = list['nome'];
                  final Color corLista = Color(int.parse(list['cor']));
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      tileColor: corLista,
                      title: Text(
                        nomeLista,
                        style: const TextStyle(fontSize: 16),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        // Ação ao clicar na lista
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        if (listas.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListaScreen()),
                  );
                },
                child: const Text(
                  "Ver Mais",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
      ],
    );
  }


  void _removeReceita(String receita) {
    setState(() {
      _ultimasReceitas.remove(receita);
    });
  }
}

class VerTodasReceitas extends StatelessWidget {
  final List<String> receitas;

  const VerTodasReceitas(this.receitas, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Todas as Receitas")),
      body: ListView.builder(
        itemCount: receitas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(receitas[index]),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SegundaTela(valor: receitas[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
