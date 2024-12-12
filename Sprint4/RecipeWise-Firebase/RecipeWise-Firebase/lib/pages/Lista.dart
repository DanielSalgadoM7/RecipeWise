import 'package:flutter/material.dart';
import 'CriarListaScreen.dart';
import 'DetalhesListaScreen.dart';
import '../services/SqlHelper/Lista_SQLHelper.dart';

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  _ListaScreenState createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  List<Map<String, dynamic>> listasFixadas = [];
  List<Map<String, dynamic>> listasComuns = [];

  @override
  void initState() {
    super.initState();
    _carregarListas();
  }

  Future<void> _carregarListas() async {
    final todasListas = await ListaSQLHelper.getListas();
    setState(() {
      listasFixadas =
          todasListas.where((lista) => lista['fixado'] == 1).toList();
      listasComuns =
          todasListas.where((lista) => lista['fixado'] == 0).toList();
    });
  }

  void _adicionarNovaLista() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CriarListaScreen(
          onListaCriada: (novaLista) {
            _carregarListas();
          },
        ),
      ),
    );
  }

  void _fixarLista(int listaId, bool fixado) async {
    await ListaSQLHelper.fixarLista(listaId, fixado);
    _carregarListas();
  }

  void _excluirLista(int listaId) async {
    await ListaSQLHelper.deleteLista(listaId);
    _carregarListas();
  }


  Widget _buildListaItem(Map<String, dynamic> lista) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Color(int.parse(lista['cor'])),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  lista['nome'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        lista['fixado'] == 1
                            ? Icons.push_pin
                            : Icons.push_pin_outlined,
                        color: Colors.blue,
                      ),
                      onPressed: () =>
                          _fixarLista(lista['id'], lista['fixado'] != 1),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _excluirLista(lista['id']),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            ExpansionTile(
              title: const Text('Itens da Lista'),
              children: [
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: ListaSQLHelper.getItens(lista['id']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return const Text('Erro ao carregar itens');
                    }
                    var itens = snapshot.data ?? [];
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itens.length,
                      itemBuilder: (context, itemIndex) {
                        var item = itens[itemIndex];
                        return Container(
                          color: Color(int.parse(lista['cor'])),
                          child: ListTile(
                            leading: Checkbox(
                              value: item['marcado'] == 1,
                              onChanged: (bool? value) {
                                setState(() {
                                  var novoItem =
                                      Map<String, dynamic>.from(item);
                                  novoItem['marcado'] = value! ? 1 : 0;
                                  ListaSQLHelper.updateItem(
                                      novoItem['id'],
                                      novoItem['quantidade'],
                                      novoItem['nome'],
                                      novoItem['marcado'] == 1);
                                });
                              },
                            ),
                            title: Text(
                              item['nome'],
                              style: TextStyle(
                                fontSize: 18,
                                color: item['marcado'] == 1
                                    ? Colors.grey
                                    : Colors.black,
                                decoration: item['marcado'] == 1
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            trailing: Text(
                              'Qtd: ${item['quantidade']}',
                              style: TextStyle(
                                color: item['marcado'] == 1
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  child: const Text("Ver Detalhes"),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetalheListaScreen(lista: lista),
                      ),
                    );
                    _carregarListas();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.shopping_cart, color: Colors.black),
            SizedBox(width: 10),
            Text(
              "Lista de Compras",
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: listasFixadas.isEmpty && listasComuns.isEmpty
          ? const Center(child: Text('Nenhuma lista criada ainda.'))
          : ListView(
              children: [
                if (listasFixadas.isNotEmpty) ...[
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      "Listas Fixadas",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...listasFixadas.map((lista) => _buildListaItem(lista)),
                ],
                if (listasComuns.isNotEmpty) ...[
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      "Outras Listas",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...listasComuns.map((lista) => _buildListaItem(lista)),
                ],
              ],
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          onPressed: _adicionarNovaLista,
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xFF942B2B),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
