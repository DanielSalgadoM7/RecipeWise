import 'package:flutter/material.dart';

class ListaScreen extends StatefulWidget {
  @override
  _ListaScreenState createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  List<Map<String, dynamic>> _items = []; // Lista de itens com seus estados e quantidades
  TextEditingController _controller = TextEditingController(); // Controlador para o campo de texto
  bool _isEditMode = false; // Controle para mostrar/ocultar a barra de adicionar itens

  void _adicionarItem() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        _items.add({'nome': _controller.text, 'marcado': false, 'quantidade': 1});
        _controller.clear(); // Limpa o campo de texto após adicionar
      }
    });
  }

  void _atualizarQuantidade(int index, int delta) {
    setState(() {
      _items[index]['quantidade'] = (_items[index]['quantidade'] + delta).clamp(1, 99); // Garante que a quantidade seja no mínimo 1
    });
  }

  void _removerItem(int index) {
    setState(() {
      _items.removeAt(index); // Remove o item da lista
    });
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode; // Alterna o modo de edição
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Compras"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            if (_isEditMode)
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Novo item',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: _adicionarItem,
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Opacity(
                    opacity: _items[index]['marcado'] ? 0.5 : 1.0,
                    child: ListTile(
                      title: Text(_items[index]['nome']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              _atualizarQuantidade(index, -1);
                            },
                          ),
                          Text(_items[index]['quantidade'].toString()),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              _atualizarQuantidade(index, 1);
                            },
                          ),
                        ],
                      ),
                      leading: Checkbox(
                        value: _items[index]['marcado'],
                        onChanged: (bool? valor) {
                          setState(() {
                            _items[index]['marcado'] = valor!;
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text("Salvar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    for (var item in _items) {
                      print("${item['nome']}: ${item['marcado'] ? 'Marcado' : 'Desmarcado'} | Quantidade: ${item['quantidade']}");
                    }
                  },
                ),
                ElevatedButton(
                  child: Text("Excluir"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _items.removeWhere((item) => item['marcado']);
                    });
                  },
                ),
                ElevatedButton(
                  child: Text("Editar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _toggleEditMode,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
