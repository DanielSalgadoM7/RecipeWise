import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../login/TelaBloqueio.dart';
import '../../services/AuthService.dart';
import '../../services/SqlHelper/Usuario_SqlHelper.dart';

var _usuario;

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  String nome = "Carregando...";
  String email = "Carregando...";
  File? _imageFile;
  Uint8List? _imageBytes;
  String? _imagePath;

  // Função para carregar os dados do usuário
  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  // Carregar os dados do usuário logado
  Future<void> _carregarDadosUsuario() async {
    int? userId = await AuthService.getUserId();

    if (userId != null) {
      // Busca os dados do usuário no banco de dados
      _usuario = await UsuarioSQLHelper.getUsuarioById(userId);
      if (_usuario != null) {
        setState(() {
          nome = _usuario['nome'];
          email = _usuario['email'];
          _imagePath = _usuario['foto'];
        });
      }
    }
  }

  // Método para escolher foto de perfil
  Future<void> _escolherFotoPerfil() async {
    final picker = ImagePicker();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Tirar Foto"),
                onTap: () async {
                  final pickedFile =
                  await picker.pickImage(source: ImageSource.camera);
                  Navigator.pop(context);
                  _processarFotoPerfilSelecionada(pickedFile);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Escolher da Galeria"),
                onTap: () async {
                  final pickedFile =
                  await picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context);
                  _processarFotoPerfilSelecionada(pickedFile);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _processarFotoPerfilSelecionada(XFile? pickedFile) async {
    if (pickedFile != null) {
      // Ler bytes da imagem
      final imageBytes = await pickedFile.readAsBytes();

      setState(() {
        _imageFile = File(pickedFile.path);
        _imageBytes = imageBytes;
        _imagePath = pickedFile.path;
      });

      // Mostrar diálogo de confirmação
      _mostrarConfirmacaoFotoPerfil();
    }
  }

  void _mostrarConfirmacaoFotoPerfil() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Foto de Perfil'),
          content: _imageBytes != null
              ? Image.memory(
            _imageBytes!,
            width: 300,
            height: 300,
            fit: BoxFit.cover,
          )
              : const Text('Nenhuma imagem selecionada'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _imageFile = null;
                  _imageBytes = null;
                  _imagePath = _usuario['foto'];
                });
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Salvar'),
              onPressed: () {
                // Salvar foto no banco de dados
                if (_imagePath != null) {
                  UsuarioSQLHelper.updateUsuario(
                    _usuario['id'],
                    _usuario['nome'],
                    _usuario['email'],
                    _imagePath!, // Salvar o caminho da imagem
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Função para editar os campos (nome e email)
  Future<void> _editarCampo(
      String campo, String valorAtual, Function(String) onSave) async {
    TextEditingController controller = TextEditingController(text: valorAtual);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar $campo'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Novo $campo",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                onSave(controller.text);
                if (campo == 'email') {
                  UsuarioSQLHelper.updateUsuario(
                      _usuario['id'],
                      _usuario['nome'],
                      controller.text,
                      _usuario['foto']);
                } else {
                  UsuarioSQLHelper.updateUsuario(
                      _usuario['id'],
                      controller.text,
                      _usuario['email'],
                      _usuario['foto']);
                }
                Navigator.of(context).pop();
              },
              child: const Text("Salvar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto de perfil com opção de edição
            Center(
              child: GestureDetector(
                onTap: _escolherFotoPerfil,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: _imageBytes != null
                          ? MemoryImage(_imageBytes!)
                          : (_imagePath != null && _imagePath!.isNotEmpty
                          ? FileImage(File(_imagePath!))
                          : const AssetImage('assets/profile_placeholder.png')
                      as ImageProvider),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "DADOS",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            // Campo para Nome
            ListTile(
              title: const Text("Nome"),
              subtitle: Text(nome),
              trailing: const Icon(Icons.edit),
              onTap: () {
                _editarCampo("nome", nome, (novoNome) {
                  setState(() {
                    nome = novoNome;
                  });
                });
              },
            ),
            // Campo para Email
            ListTile(
              title: const Text("email"),
              subtitle: Text(email),
              trailing: const Icon(Icons.edit),
              onTap: () {
                _editarCampo("Email", email, (novoEmail) {
                  setState(() {
                    email = novoEmail;
                  });
                });
              },
            ),
            const SizedBox(height: 30),

            // Botão para Sobre o App
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(180, 50), // Botão maior
                ),
                onPressed: () {
                  // Navegar para a nova página "Sobre o App"
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SobreSiteScreen()),
                  );
                },
                child: const Text("Sobre o App"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Resto do código original mantido igual (SobreSiteScreen)
class SobreSiteScreen extends StatefulWidget {
  const SobreSiteScreen({super.key});

  @override
  _SobreSiteScreenState createState() => _SobreSiteScreenState();
}

class _SobreSiteScreenState extends State<SobreSiteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre o App"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/images/LOGOicon.jpg',
                  width: 150,
                  height: 150,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "RecipeWise é um aplicativo mobile desenvolvido nas aulas de Laboratório e Desenvolvimento de Dispositivos Móveis da PUC Minas...",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Os integrantes do grupo são:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "André Mendes\nArthur Martinho\nCaio Gomes\nDaniel Salgado",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}