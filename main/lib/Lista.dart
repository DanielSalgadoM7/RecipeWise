import 'package:flutter/material.dart';
import 'CriarListaScreen.dart';
import 'DetalhesListaScreen.dart';
import 'SqlHelper/Lista_SQLHelper.dart'; // Importe seu SQLHelper

class ListaScreen extends StatefulWidget {
  @override
  _ListaScreenState createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  List<Map<String, dynamic>> listas = [];

  @override
  void initState() {
    super.initState();
    _carregarListas();
  }

  Future<void> _carregarListas() async {
    final dataListas = await ListaSQLHelper().getListas();
    setState(() {
      listas = dataListas;
    });
  }

  void _adicionarNovaLista() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CriarListaScreen(
          onListaCriada: (novaLista) {
            _carregarListas(); // Recarrega a lista após a criação
          },
        ),
      ),
    );
  }

  void _toggleItemStatus(int listaIndex, int itemIndex) async {
    var item = listas[listaIndex]['itens'][itemIndex];
    await ListaSQLHelper().updateItem(item['id'], !item['marcado']);
    _carregarListas(); // Recarrega a lista após a atualização
  }

  // Método para converter o ID da cor em Color
  Color _getColorFromId(int id) {
    switch (id) {
      case 0:
        return Colors.pink[200]!;
      case 1:
        return Colors.blue[200]!;
      case 2:
        return Colors.green[200]!;
      case 3:
        return Colors.purple[200]!;
      case 4:
        return Colors.orange[200]!;
      default:
        return Colors.black; // Cor padrão se o ID não for válido
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
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
      body: listas.isEmpty
          ? Center(child: Text('Nenhuma lista criada ainda.'))
          : ListView.builder(
        itemCount: listas.length,
        itemBuilder: (context, listaIndex) {
          var lista = listas[listaIndex];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: _getColorFromId(lista['cor']), // Converte o ID da cor para Color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome da lista
                  Text(
                    lista['nome'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Exibir itens da lista com checkboxes
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: ListaSQLHelper().getItens(lista['id']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Erro ao carregar itens');
                      }

                      var itens = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: itens.length,
                        itemBuilder: (context, itemIndex) {
                          var item = itens[itemIndex];
                          return Container(
                            color: _getColorFromId(lista['cor']).withOpacity(0.3),
                            child: ListTile(
                              leading: Checkbox(
                                value: item['marcado'] == 1,
                                onChanged: (bool? value) {
                                  _toggleItemStatus(listaIndex, itemIndex);
                                },
                              ),
                              title: Text(
                                item['nome'],
                                style: TextStyle(
                                  fontSize: 18,
                                  color: item['marcado'] == 1 ? Colors.grey : Colors.black,
                                  decoration: item['marcado'] == 1 ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              trailing: Text(
                                'Qtd: ${item['quantidade']}',
                                style: TextStyle(
                                  color: item['marcado'] == 1 ? Colors.grey : Colors.black,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    child: Text("Ver Detalhes"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetalheListaScreen(lista: lista),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarNovaLista,
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF942B2B),
      ),
    );
  }
}
