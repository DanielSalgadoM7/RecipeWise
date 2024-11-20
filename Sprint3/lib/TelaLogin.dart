import 'package:flutter/material.dart';
import 'SqlHelper/Usuario_SqlHelper.dart'; // Importe a classe UsuarioSQLHelper
import 'Perfil.dart'; // Importe a tela de perfil

class TelaLogin extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  void fazerLogin(BuildContext context) async {
    String email = emailController.text.trim();
    String senha = senhaController.text.trim();

    // Verificar se os campos estão preenchidos
    if (email.isEmpty || senha.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    // Consultar o banco para verificar o login
    final usuario = await UsuarioSQLHelper.getUsuarioByEmailSenha(email, senha);
    if (usuario != null) {
      // Login bem-sucedido, navega para a tela de perfil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Perfil()), // Tela para onde o usuário será redirecionado
      );
    } else {
      // Mostrar mensagem de erro se o login falhar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('E-mail ou senha incorretos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          backgroundColor: Colors.red.shade700,
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Center(
              child: Image.asset(
                'assets/images/LOGOicon.jpg',
                width: 80,
                height: 80,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Text(
              "Entrar no App",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => fazerLogin(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "ENTRAR",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
