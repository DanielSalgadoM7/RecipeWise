/*import 'package:flutter/material.dart';

FODASE
import '../main.dart'; // Importar o arquivo principal para acessar a lista global

String usuario = "Usuário";

class ListaScreen extends StatefulWidget {
  const ListaScreen({super.key});

  @override
  _ListaScreenState createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _listaNomeController =
      TextEditingController(text: "Lista de $usuario");
  Color _listaColor = Colors.pink[200]!; // Cor inicial da lista

  final List<Color> coresDisponiveis = [
    Colors.pink[200]!,
    Colors.blue[200]!,
    Colors.green[200]!,
    Colors.purple[200]!,
    Colors.orange[200]!,
  ];

  void _adicionarItem() {
    setState(() {
      if (_controller.text.isNotEmpty) {
        listaDeCompras
            .add({'nome': _controller.text, 'marcado': false, 'quantidade': 1});
        _controller.clear();
      }
    });
  }

  void _atualizarQuantidade(int index, int delta) {
    setState(() {
      listaDeCompras[index]['quantidade'] =
          (listaDeCompras[index]['quantidade'] + delta).clamp(1, 99);
    });
  }

  void _removerItem(int index) {
    setState(() {
      listaDeCompras.removeAt(index);
    });
  }

  void _confirmarExcluirTudo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmação"),
          content:
              const Text("Tem certeza de que deseja excluir todos os itens?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Excluir"),
              onPressed: () {
                setState(() {
                  listaDeCompras.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    double paddingHorizontal = larguraTela * 0.05;
    double paddingVertical = larguraTela * 0.025;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: _listaColor,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Center(
                child: TextField(
                  controller: _listaNomeController,
                  decoration: const InputDecoration(
                    hintText: 'Digite o nome da lista',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: coresDisponiveis.map((cor) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _listaColor = cor;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: cor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Novo item',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2.0),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    cursorColor: Colors.black,
                    onSubmitted: (_) => _adicionarItem(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _adicionarItem,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listaDeCompras.length,
                itemBuilder: (context, index) {
                  bool isChecked = listaDeCompras[index]['marcado'];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: isChecked ? Colors.grey[300] : Colors.white,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      leading: Checkbox(
                        value: isChecked,
                        activeColor: Colors.grey,
                        checkColor: Colors.white,
                        onChanged: (bool? valor) {
                          setState(() {
                            listaDeCompras[index]['marcado'] = valor!;
                          });
                        },
                      ),
                      title: Text(
                        listaDeCompras[index]['nome'],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isChecked ? Colors.grey[600] : Colors.black,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                _atualizarQuantidade(index, -1);
                              },
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: Colors.black),
                              ),
                              child: Text(
                                listaDeCompras[index]['quantidade'].toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                _atualizarQuantidade(index, 1);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _removerItem(index);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                    vertical: paddingVertical, horizontal: paddingHorizontal),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: larguraTela * 0.04),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _confirmarExcluirTudo,
              child: Text("EXCLUIR TODOS"),
            ),
          ],
        ),
      ),
    );
  }
}
*/