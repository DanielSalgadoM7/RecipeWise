import 'package:flutter/material.dart';

class Telabloqueio extends StatelessWidget {
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
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Mensagem de orientação
            Text(
              "OPS... Vimos que você ainda não se cadastrou ou não está logado :(",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Para continuar usando nosso APP realize alguma das opções abaixo!",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),

            // Botão de Fazer Cadastro
            SizedBox(
              width: double.infinity, // Garante que o botão ocupe toda a largura
              child: ElevatedButton(
                onPressed: () {
                  // Navegar para a tela de cadastro
                  Navigator.pushNamed(context, '/cadastro');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Cor de fundo do botão
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "FAZER CADASTRO",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 15),

            // Botão de Fazer Login
            SizedBox(
              width: double.infinity, // Garante que o botão ocupe toda a largura
              child: ElevatedButton(
                onPressed: () {
                  // Navegar para a tela de login
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Cor de fundo do botão
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "FAZER LOGIN",
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
