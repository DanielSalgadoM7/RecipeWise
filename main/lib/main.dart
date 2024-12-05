import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:main/pages/TelaBloqueio.dart';
import 'pages/Lista.dart';
import 'pages/PrimeiraTela.dart';
import 'pages/Receitas.dart';
import 'pages/Perfil.dart';
import 'pages/CriarReceita/Publicar.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';

List<Map<String, dynamic>> listaDeCompras = [];
final GlobalKey<_InicioState> _inicioKey = GlobalKey<_InicioState>();



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Inicio(key: _inicioKey),
  ));
}

class Inicio extends StatefulWidget {
  Inicio({Key? key}) : super(key: key);
  @override
  _InicioState createState() => _InicioState();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu App',
      initialRoute: '/',
      routes: {
        '/': (context) => PrimeiraTela(),
        '/telabloqueio': (context) => Telabloqueio(),
      },
    );
  }
}

class _InicioState extends State<Inicio> {
  int _indiceAtual = 0;
  File? _profileImage; // Variável para armazenar a imagem do perfil

  final List<Widget> _telas = [
    PrimeiraTela(),
    Publicar(),
    Receitas(),
    ListaScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileImage(); // Carrega a imagem do perfil ao iniciar
  }

  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('imagem_perfil');
    if (path != null) {
      setState(() {
        _profileImage = File(path);
      });
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }

  void mudarParaReceitas() {
    setState(() {
      _indiceAtual = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    String usuario = "Usuário";

    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            setState(() {
              _indiceAtual = 0;
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
                    fontSize: 18,
                  ),
                ),
              ),
              IconButton(
                icon: SizedBox(
                  width: 56,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                          color: Color(0xFF942B2B), width: 2),
                    ),
                    child: Center(
                      child: _profileImage != null
                          ? ClipOval(
                        child: Image.file(
                          _profileImage!,
                          width: 50, // Largura da imagem de perfil
                          height: 70, // Altura da imagem de perfil
                          fit: BoxFit.cover, // Ajusta a imagem para cobrir o espaço
                        ),
                      )
                          : Icon(
                        Icons.person,
                        color: Color(0xFF942B2B),
                        size: 30,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Perfil()),
                  ).then((_) {
                    // Atualiza a imagem de perfil ao retornar para a tela inicial
                    _loadProfileImage();
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: _telas[_indiceAtual],

      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.react,
        backgroundColor: Color(0xFF942B2B),
        items: [
          TabItem(icon: Icons.home, title: "Início"),
          TabItem(icon: Icons.add_circle, title: "Publicar"),
          TabItem(icon: Icons.fastfood, title: "Receitas"),
          TabItem(icon: Icons.list_alt, title: "Lista"),
        ],
        initialActiveIndex: _indiceAtual,
        onTap: onTabTapped,
      ),
    );
  }
}
