import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login/TelaBloqueio.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  String nome = "xxxxxxx";
  String email = "xxxxxxxxx@gmail.com";
  String telefone = "0000-0000";
  String receitasPublicadas = "0";
  String categoriaPreferida = "nenhuma"; // Categoria padrão
  File? _image; // Variável para armazenar a imagem escolhida
  final picker = ImagePicker(); // Instância do ImagePicker

  List<String> categorias = [
    "Doces",
    "Salgados",
    "Cítricos",
    "Picantes",
    "Saudáveis"
  ]; // Opções de categorias
  bool _isExpanded = false; // Controla se a lista de categorias está expandida

  // Função para pegar imagem da galeria ou câmera
  @override
  void initState() {
    super.initState();
    _loadImage(); // Carregar a imagem salva ao inicializar a tela
  }

  // Função para pegar imagem da galeria ou câmera
  Future<void> _escolherImagem(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await _saveImagePath(pickedFile.path); // Salvar o caminho da imagem
    }
  }

  // Salvar o caminho da imagem no SharedPreferences
  Future<void> _saveImagePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('imagem_perfil', path);
  }

  // Carregar a imagem salva ao iniciar a tela
  Future<void> _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('imagem_perfil');
    if (path != null) {
      setState(() {
        _image = File(path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto de perfil
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: _image != null
                        ? FileImage(_image!) // Mostra a imagem selecionada
                        : AssetImage('assets/profile_placeholder.png')
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: PopupMenuButton<ImageSource>(
                      icon: Icon(Icons.camera_alt, color: Colors.blue),
                      onSelected: (ImageSource source) {
                        _escolherImagem(source); // Função para escolher imagem
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<ImageSource>>[
                        const PopupMenuItem<ImageSource>(
                          value: ImageSource.gallery,
                          child: Text('Selecionar da Galeria'),
                        ),
                        const PopupMenuItem<ImageSource>(
                          value: ImageSource.camera,
                          child: Text('Tirar Foto'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              "DADOS",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            // Campo para Nome
            ListTile(
              title: Text("Nome"),
              subtitle: Text(nome),
              trailing: Icon(Icons.edit),
              onTap: () {
                _editarCampo("Nome", nome, (novoNome) {
                  setState(() {
                    nome = novoNome;
                  });
                });
              },
            ),

            ListTile(
              title: Text("Telefone"),
              subtitle: Text(telefone),
              trailing: Icon(Icons.edit),
              onTap: () {
                _editarCampo("Telefone", telefone, (novoTelefone) {
                  setState(() {
                    email = novoTelefone;
                  });
                });
              },
            ),
            // Campo para Email
            ListTile(
              title: Text("Email"),
              subtitle: Text(email),
              trailing: Icon(Icons.edit),
              onTap: () {
                _editarCampo("Email", email, (novoEmail) {
                  setState(() {
                    email = novoEmail;
                  });
                });
              },
            ),

            Divider(),
            SizedBox(height: 10),
            Text(
              "INFORMAÇÕES:",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            // Número de Receitas Publicadas
            ListTile(
              title: Text("Número de Receitas Publicadas"),
              subtitle: Text(receitasPublicadas),
            ),

            // Seção para Categoria Preferida
            ExpansionTile(
              title: Text("Categoria Preferida"),
              subtitle: Text(categoriaPreferida),
              trailing: Icon(
                _isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: Colors.red,
              ),
              onExpansionChanged: (bool expanded) {
                setState(() {
                  _isExpanded = expanded;
                });
              },
              children: categorias.map((categoria) {
                return ListTile(
                  title: Text(
                    categoria,
                    style: TextStyle(
                      fontWeight: categoria == categoriaPreferida
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      categoriaPreferida = categoria;
                      _isExpanded = false; // Fecha a expansão ao selecionar
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 30),

            // Botão para Fazer Cadastro
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  minimumSize:
                      Size(150, 40), // Tamanho padrão do botão "Fazer cadastro"
                ),
                onPressed: () {
                  print("Botão pressionado");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Telabloqueio()),
                  );
                },
                child: Text("Cria Conta"),
              ),
            ),

            SizedBox(height: 20),

            // Botão para Sobre o Site (um pouco maior)
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(180, 50), // Botão ligeiramente maior
                ),
                onPressed: () {
                  // Navegar para a nova página "Sobre o Site"
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SobreSiteScreen()),
                  );
                },
                child: Text("Sobre o App"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para abrir diálogo de edição de texto
  Future<void> _editarCampo(
      String campo, String valorAtual, Function(String) onSave) async {
    TextEditingController _controller = TextEditingController(text: valorAtual);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar $campo'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Novo $campo",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Cor do botão vermelho
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                onSave(_controller.text);
                Navigator.of(context).pop();
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }
}

// Nova tela Sobre o Site
class SobreSiteScreen extends StatefulWidget {
  @override
  _SobreSiteScreenState createState() => _SobreSiteScreenState();
}

class _SobreSiteScreenState extends State<SobreSiteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
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
        title: Text("Sobre o App"),
      ),
      body: SingleChildScrollView( // Adicionado para rolagem automática
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/images/LOGOicon.jpg', // Caminho da imagem
                  width: 150, // Largura da imagem
                  height: 150, // Altura da imagem
                ),
              ),
            ),
            SizedBox(height: 20),

            // Texto de descrição
            Text(
              "RecipeWise é um aplicativo mobile desenvolvido nas aulas de Laboratório e Desenvolvimento de Dispositivos Móveis da PUC Minas. O aplicativo é focado em criar uma facilidade maior para o usuário em relação a decisão de comidas para preparar, mostrando receitas feitas por outras pessoas, e uma lista de compras para facilitar à ida ao mercado, analisando a quantidade necessária de cada item.Juntamente das receitas já prontas, o usuário é capaz de criar a sua própria versão de alguma receita e mostrar ao mundo, utilizando de sua própria câmera do telefone para mostrar o resultado final. O objetivo do projeto é fazer com que as pessoas tenham uma melhor experiência na cozinha, sendo capazes de desenvolver habilidades culinárias, até seguindo as receitas mais difíceis.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),

            // Integrantes do grupo
            Text(
              "Os integrantes do grupo são:",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "André Mendes\nArthur Martinho\nCaio Gomes\nDaniel Salgado",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
