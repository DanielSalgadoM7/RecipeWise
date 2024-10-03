import 'package:flutter/material.dart';
import 'Lista.dart';
import 'PrimeiraTela.dart';
import 'Receitas.dart'; // Importar a página de Receitas
import 'Perfil.dart'; // Importar a página de Perfil
import 'Publicar.dart'; // Importar a página de Publicar
import 'package:convex_bottom_bar/convex_bottom_bar.dart'; // Importar o Convex Bottom Bar

List<Map<String, dynamic>> listaDeCompras = [];
final GlobalKey<_InicioState> _inicioKey = GlobalKey<_InicioState>();

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Inicio(key: _inicioKey), // Passando a chave para o Inicio
  ));
}

class Inicio extends StatefulWidget {
  Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _indiceAtual = 0;
  final List<Widget> _telas = [
    PrimeiraTela(),
    Publicar(), // Tela de Publicar
    Receitas(),
    ListaScreen(), // Tela de Lista
  ];

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }

  void mudarParaReceitas() {
    setState(() {
      _indiceAtual = 2; // Muda para a página de Receitas
    });
  }

  @override
  Widget build(BuildContext context) {
    // Defina o nome do usuário aqui
    String usuario = "Usuário"; // Você pode mudar isso para um nome dinâmico

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            setState(() {
              _indiceAtual = 0; // Volta para a tela inicial
            });
          },
          child: SizedBox(
            width: 120,
            height: 50,
            child: Image.asset(
              'assets/images/RecipeWiseLogo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        backgroundColor: Color(0xFF942B2B),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Olá, $usuario!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18, // Tamanho da fonte
                  ),
                ),
              ),
              IconButton(
                icon: SizedBox(
                  width: 56, // Largura do botão
                  height: 56, // Altura do botão
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Faz com que o fundo seja circular
                      color: Colors.white, // Cor de fundo
                      border: Border.all(
                          color: Color(0xFF942B2B), width: 2), // Borda vermelha fina
                    ),
                    child: Center( // Centraliza o ícone
                      child: Icon(
                        Icons.person,
                        color: Color(0xFF942B2B), // Cor do ícone
                        size: 30, // Tamanho do ícone
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Perfil()), // Navega para a tela de Perfil
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: _telas[_indiceAtual],

      // Usando ConvexAppBar no lugar do BottomNavigationBar
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react, // Define o estilo do ConvexAppBar
        backgroundColor: Color(0xFF942B2B), // Cor de fundo
        items: [
          TabItem(icon: Icons.home, title: "Início"),
          TabItem(icon: Icons.add_circle, title: "Publicar"),
          TabItem(icon: Icons.fastfood, title: "Receitas"),
          TabItem(icon: Icons.list_alt, title: "Lista"),
        ],
        initialActiveIndex: _indiceAtual, // Índice inicial ativo
        onTap: onTabTapped, // Função para manipular as mudanças de aba
      ),
    );
  }
}
