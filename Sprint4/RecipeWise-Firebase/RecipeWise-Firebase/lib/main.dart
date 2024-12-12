import 'dart:io';
import 'package:flutter/material.dart';
import 'package:main/services/AuthService.dart';
import 'package:main/services/SqlHelper/Usuario_SqlHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login/TelaBloqueio.dart';
import 'pages/Lista.dart';
import 'pages/Home/PrimeiraTela.dart';
import 'pages/Receitas.dart';
import 'pages/Perfil/Perfil.dart';
import 'pages/CriarReceita/Publicar.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart'; // Para `kIsWeb`

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

List<Map<String, dynamic>> listaDeCompras = [];
final GlobalKey<_InicioState> _inicioKey = GlobalKey<_InicioState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização do Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inicialização do sqflite
  sqfliteFfiInit();
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb; // Configuração para Web
  } else {
    databaseFactory =
        databaseFactoryFfi; // Configuração para outras plataformas
  }

  // Verifica se o usuário está logado
  final isLoggedIn = await AuthService.isUserLogged();
  final userId = isLoggedIn ? await AuthService.getUserId() : null;

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    userId: userId,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final int? userId;

  const MyApp({super.key, required this.isLoggedIn, this.userId});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? Inicio(userId: userId!) // Passa o userId para o widget Inicio
          : Telabloqueio(),
      routes: {
        '/perfil': (context) => Perfil(),
      },
    );
  }
}

class Inicio extends StatefulWidget {
  final int userId;

  const Inicio({super.key, required this.userId});

  @override
  _InicioState createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  int _indiceAtual = 0;
  File? _profileImage;
  String usuario = 'Carregando...';

  final List<Widget> _telas = [
    PrimeiraTela(), // Sempre carrega PrimeiraTela
    Publicar(),
    Receitas(),
    ListaScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadUsuario();
    _loadProfileImage();
  }

  Future<void> _loadUsuario() async {
    var user = await UsuarioSQLHelper.getUsuarioById(widget.userId);
    setState(() {
      usuario = user != null ? user['nome'] : 'Usuário desconhecido';
    });
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
                      border:
                          Border.all(color: const Color(0xFF942B2B), width: 2),
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
