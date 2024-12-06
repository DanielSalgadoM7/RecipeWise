import 'dart:io';
import 'package:flutter/material.dart';
import 'package:main/services/AuthService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login/TelaBloqueio.dart';
import 'pages/Lista.dart';
import 'pages/Home/PrimeiraTela.dart';
import 'pages/Receitas.dart';
import 'pages/Perfil.dart';
import 'pages/CriarReceita/Publicar.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';

List<Map<String, dynamic>> listaDeCompras = [];
final GlobalKey<_InicioState> _inicioKey = GlobalKey<_InicioState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Verifica se o usuário está logado
  final bool isLoggedIn = await AuthService.isUserLogged();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? Inicio(key: _inicioKey) : Telabloqueio(),  // A tela inicial agora é sempre PrimeiraTela
      routes: {
        '/perfil': (context) => Perfil(),
      },
    );
  }
}

class Inicio extends StatefulWidget {
  Inicio({Key? key}) : super(key: key);

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _indiceAtual = 0;
  File? _profileImage;

  final List<Widget> _telas = [
    PrimeiraTela(),  // Sempre carrega PrimeiraTela
    Publicar(),
    Receitas(),
    ListaScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
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
        backgroundColor: const Color(0xFF942B2B),
        actions: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  "Olá, $usuario!",
                  style: const TextStyle(
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
                          color: const Color(0xFF942B2B), width: 2),
                    ),
                    child: Center(
                      child: _profileImage != null
                          ? ClipOval(
                        child: Image.file(
                          _profileImage!,
                          width: 50,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      )
                          : const Icon(
                        Icons.person,
                        color: Color(0xFF942B2B),
                        size: 30,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/perfil').then((_) {
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
        backgroundColor: const Color(0xFF942B2B),
        items: const [
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
