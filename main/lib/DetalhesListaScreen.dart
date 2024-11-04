import 'package:flutter/material.dart';
import 'SqlHelper/Lista_SQLHelper.dart'; // Importe seu SQLHelper

class DetalheListaScreen extends StatefulWidget {
  final Map<String, dynamic> lista;

  DetalheListaScreen({required this.lista});

  @override
  _DetalheListaScreenState createState() => _DetalheListaScreenState();
}

class _DetalheListaScreenState extends State<DetalheListaScreen> {
  TextEditingController _controller = TextEditingController();

  void _adicionarItem() async {
    if (_controller.text.isNotEmpty) {
      await ListaSQLHelper().createItem(widget.lista['id'], _controller.text, false, 1);
      _controller.clear();
      setState(() {}); // Recarrega a lista de itens
    }
  }

  void _atualizarQuantidade(int index, int delta) async {
    var item = widget.lista['itens'][index];
    int novaQuantidade = (item['quantidade'] + delta).clamp(1, 99);

    await ListaSQLHelper().updateItem(item['id'], item['marcado'] == 1);
    await ListaSQLHelper().updateItemQuantidade(item['id'], novaQuantidade);
    setState(() {}); // Recarrega a lista de itens
  }

  void _removerItem(int index) async {
    var item = widget.lista['itens'][index];
    await ListaSQLHelper().deleteItem(item['id']);
    setState(() {}); // Recarrega a lista de itens
  }

  Future<List<Map<String, dynamic>>> _carregarItens() async {
    return await ListaSQLHelper().getItens(widget.lista['id']);
  }

  @override
  void initState() {
    super.initState();
    _carregarItens().then((itens) {
      setState(() {
        widget.lista['itens'] = itens; // Atualiza a lista de itens com os dados do banco
      });
    });
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
        backgroundColor: _getColorFromId(widget.lista['cor']), // Usar a cor da lista
        title: Text(widget.lista['nome']),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Novo item'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _adicionarItem,
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _carregarItens(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar itens.'));
                }

                var itens = snapshot.data!;

                return ListView.builder(
                  itemCount: itens.length,
                  itemBuilder: (context, index) {
                    var item = itens[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: item['marcado'] == 1 ? Colors.grey[300] : Colors.white,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(8),
                        leading: Checkbox(
                          value: item['marcado'] == 1,
                          onChanged: (bool? valor) {
                            setState(() {
                              item['marcado'] = valor! ? 1 : 0;
                              ListaSQLHelper().updateItem(item['id'], item['marcado'] == 1);
                            });
                          },
                        ),
                        title: Text(
                          item['nome'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: item['marcado'] == 1 ? Colors.grey[600] : Colors.black,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _atualizarQuantidade(index, -1),
                            ),
                            Text(
                              item['quantidade'].toString(),
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _atualizarQuantidade(index, 1),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () => _removerItem(index),
                            ),
                          ],
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
    );
  }
}
