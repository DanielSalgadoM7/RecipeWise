import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../login/TelaBloqueio.dart';
import '../../services/AuthService.dart';
import '../../services/SqlHelper/Usuario_SqlHelper.dart'; // Caso você esteja puxando os dados do banco

var _usuario;

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  String nome = "Carregando...";
  String email = "Carregando...";

  // Função para carregar os dados do usuário
  @override
  void initState() {
    super.initState();
    _carregarDadosUsuario();
  }

  // Carregar os dados do usuário logado
  Future<void> _carregarDadosUsuario() async {
    int? userId = await AuthService.getUserId(); // Pega o id do usuário logado

    if (userId != null) {
      // Busca os dados do usuário no banco de dados
      _usuario = await UsuarioSQLHelper.getUsuarioById(userId);
      if (_usuario != null) {
        setState(() {
          nome = _usuario['nome'];
          email = _usuario['email'];
        });
      }
    }
  }

  // Função para editar os campos (nome e email)
  Future<void> _editarCampo(String campo, String valorAtual, Function(String) onSave) async {
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
                if(campo == 'email') {
                  UsuarioSQLHelper.updateUsuario(
                      _usuario['id'],
                      _usuario['nome'],
                      _controller.text, // Passando o valor de _controller.text em vez de _controller
                      _usuario['foto']
                  );
                }else{
                  UsuarioSQLHelper.updateUsuario(
                      _usuario['id'],
                      _controller.text,
                      _usuario['email'],
                      _usuario['foto']);
                }
                Navigator.of(context).pop();
              },
              child: Text("Salvar"),
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
        title: Text("Perfil"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto de perfil (mantida como placeholder)
            Center(
              child: CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/profile_placeholder.png'),
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
                _editarCampo("nome", nome, (novoNome) {
                  setState(() {
                    nome = novoNome;
                  });
                });
              },
            ),
            // Campo para Email
            ListTile(
              title: Text("email"),
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
            SizedBox(height: 30),

            // Botão para Sobre o App
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: Size(180, 50), // Botão maior
                ),
                onPressed: () {
                  // Navegar para a nova página "Sobre o App"
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
}

// Tela Sobre o App
class SobreSiteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sobre o App"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/images/LOGOicon.jpg', // Caminho da imagem
                width: 150, // Largura da imagem
                height: 150, // Altura da imagem
              ),
            ),
            SizedBox(height: 20),
            Text(
              "RecipeWise é um aplicativo mobile desenvolvido nas aulas de Laboratório e Desenvolvimento de Dispositivos Móveis da PUC Minas...",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            Text(
              "Os integrantes do grupo são:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "André Mendes\nArthur Martinho\nCaio Gomes\nDaniel Salgado",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
