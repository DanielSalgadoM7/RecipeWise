import 'package:flutter/material.dart';

class TelaCadastro extends StatelessWidget {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de navegação com fundo vermelho
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120), // Altura maior da AppBar
        child: AppBar(
          backgroundColor: Colors.red.shade700, // Cor de fundo vermelha
          elevation: 0, // Retira a sombra da barra
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 40.0), // Ajuste a altura do ícone
            child: Center(
              child: Image.asset(
                'assets/images/LOGOicon.jpg', // Caminho para a imagem nos arquivos do projeto
                width: 80,
                height: 80,
              ),
            ),
          ),
        ),
      ),

      // Conteúdo principal da tela
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, // Alinha o conteúdo no topo
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            // Título de Cadastro
            Text(
              "Cadastro de Usuário",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Menor espaçamento após o título

            // Campo para nome
            TextField(
              controller: nomeController,
              decoration: InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10),

            // Campo para e-mail
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

            // Campo para telefone
            TextField(
              controller: telefoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Telefone',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            SizedBox(height: 10),

            // Campo para senha
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

            // Botão de Cadastro
            SizedBox(
              width: double.infinity, // Garante que o botão ocupe toda a largura
              child: ElevatedButton(
                onPressed: () {
                  // Lógica para concluir o cadastro (pode incluir validações)
                  String nome = nomeController.text;
                  String email = emailController.text;
                  String telefone = telefoneController.text;
                  String senha = senhaController.text;

                  // Aqui você pode incluir validações e persistência dos dados

                  // Navegar de volta para a tela principal após o cadastro
                  Navigator.pop(context); // Voltar para a tela anterior (Telabloqueio)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Cor de fundo do botão
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "CADASTRAR",
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
