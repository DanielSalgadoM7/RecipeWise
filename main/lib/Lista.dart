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
    final dataListas = await ListaSQLHelper.getListas();
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

  // Função para excluir a lista
  void _excluirLista(int listaId) async {
    await ListaSQLHelper.deleteLista(listaId); // Deleta a lista do banco de dados
    _carregarListas(); // Recarrega as listas
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
            color: Color(int.parse(lista['cor'])), // Converte o ID da cor para Color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nome da lista e botão de excluir no canto superior direito
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lista['nome'],
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _excluirLista(lista['id']),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Expansão dos itens da lista
                  ExpansionTile(
                    title: Text('Itens da Lista'),
                    children: [
                      FutureBuilder<List<Map<String, dynamic>>>( // Carrega os itens da lista
                        future: ListaSQLHelper.getItens(lista['id']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text('Erro ao carregar itens');
                          }

                          var itens = snapshot.data ?? [];
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
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
                                        var novoItem = Map<String, dynamic>.from(item);
                                        novoItem['marcado'] = value! ? 1 : 0;
                                        ListaSQLHelper.updateItem(novoItem['id'], novoItem['quantidade'], novoItem['nome'], novoItem['marcado'] == 1);
                                      });
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
                        onPressed: () async {
                          // Espera o retorno da tela de detalhes
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetalheListaScreen(lista: lista),
                            ),
                          );
                          // Após voltar de DetalheListaScreen, recarrega as listas
                          _carregarListas();
                        },
                      ),
                    ],
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
