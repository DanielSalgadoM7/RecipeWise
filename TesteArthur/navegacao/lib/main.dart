import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Lista.dart'; // Importar a tela de lista de outro arquivo

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Inicio(),
  ));
}

class Inicio extends StatefulWidget {
  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _indiceAtual = 0;
  final List<Widget> _telas = [
    PrimeiraTela(),
    Perfil("Meu Perfil"),
    Receitas("Minhas Receitas"),
    ListaScreen()  // Alterado para chamar o ListaScreen de Lista.dart
  ];

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          alignment: Alignment.center,  // Centraliza o título
          children: [
            // Linha vermelha atrás do título
            Positioned(
              bottom: 0,
              child: Container(
                height: 5,
                width: 150, // Define a largura da linha vermelha
                color: Colors.red, // Cor da linha
              ),
            ),
            // Texto do título
            Text(
              "Recipe Wise",
              style: TextStyle(
                color: Colors.white,  // Cor do texto em branco
                fontSize: 24,         // Tamanho do texto
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red, // Cor de fundo da AppBar
      ),
      body: _telas[_indiceAtual],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Início", backgroundColor: Colors.red),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil", backgroundColor: Colors.red),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: "Receitas", backgroundColor: Colors.red),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Lista", backgroundColor: Colors.red),
        ],
      ),
    );
  }
}

// Código da Primeira Tela com Navegação para a Segunda Tela
class PrimeiraTela extends StatefulWidget {
  @override
  _PrimeiraTelaState createState() => _PrimeiraTelaState();
}

class _PrimeiraTelaState extends State<PrimeiraTela> {
  TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),

      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  labelText: "Busque uma receita: "
              ),
              style: TextStyle(
                fontSize: 30,
              ),
              controller: _textEditingController,
            ),
            ElevatedButton(
                child: Text("BUSCAR"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SegundaTela(valor: _textEditingController.text)
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}

// Código da Segunda Tela que recebe o valor
class SegundaTela extends StatelessWidget {
  final String valor;

  SegundaTela({required this.valor});

  // Função para abrir o link
  void _abrirLink() async {
    const url = 'https://receitas.globo.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receitas"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "A receita buscada foi: $valor",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20), // Espaçamento entre o texto e o botão
            ElevatedButton(
              onPressed: _abrirLink, // Chama a função para abrir o link
              child: Text("Abrir $valor"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// As demais telas são placeholders. Aqui estão alguns exemplos básicos.

class Perfil extends StatelessWidget {
  final String texto;
  Perfil(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(texto),
      ),
    );
  }
}

class Receitas extends StatelessWidget {
  final String texto;
  Receitas(this.texto);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(texto),
      ),
    );
  }
}
