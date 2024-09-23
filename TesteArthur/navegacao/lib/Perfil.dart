import 'package:flutter/material.dart';

class EntradaCheckBox extends StatefulWidget {
  @override
  _EntradaCheckBoxState createState() => _EntradaCheckBoxState();
}

class _EntradaCheckBoxState extends State<EntradaCheckBox> {
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

  // Função para verificar se há uma imagem associada ao item
  Widget _getImagemAssociada(String nomeItem) {
    String nomeNormalizado = nomeItem.toLowerCase(); // Converte para minúsculas para comparação
    if (nomeNormalizado == 'ovo') {
      return Container(
        color: Colors.white,
        child: Center(
          child: Image.asset('assets/Ovo.jpg'),
        ),
      );
    }
    // Pode adicionar mais condições para outros itens, como leite, pão, etc.
    return SizedBox.shrink(); // Retorna um widget vazio se não houver imagem associada
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Carla"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Apenas exibe a barra de adicionar itens se estiver no modo de edição
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
                    opacity: _items[index]['marcado'] ? 0.5 : 1.0, // Fica opaco se marcado
                    child: ListTile(
                      title: Text(_items[index]['nome']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              _atualizarQuantidade(index, -1); // Decrementa quantidade
                            },
                          ),
                          Text(_items[index]['quantidade'].toString()), // Exibe a quantidade
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              _atualizarQuantidade(index, 1); // Incrementa quantidade
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
                      print(
                          "${item['nome']}: ${item['marcado'] ? 'Marcado' : 'Desmarcado'} | Quantidade: ${item['quantidade']}");
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
                    // Exclui todos os itens que estão marcados
                    setState(() {
                      _items.removeWhere((item) => item['marcado']);
                    });
                  },
                ),
                ElevatedButton(
                  child: Text("Editar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Botão laranja
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _toggleEditMode, // Alterna o modo de edição
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
