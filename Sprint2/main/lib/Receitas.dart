import 'package:flutter/material.dart';
import 'ReceitasTelas/BoloDeCenoura.dart';

class Receitas extends StatelessWidget {
  final bool fromPrimeiraTela;

  Receitas({this.fromPrimeiraTela = false});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (fromPrimeiraTela) {
          Navigator.pop(context);
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Receitas"),
          leading: fromPrimeiraTela
              ? IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )
              : null,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Barra de pesquisa
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Pesquisar...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navega para a tela de detalhes do Bolo de Cenoura
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoloDeCenoura(), // Certifique-se de que o nome é exatamente este
                          ),
                        );
                      },
                      child: _buildReceitaCard(
                        'Bolo de cenoura com chocolate',
                        'Delicioso bolo de cenoura com chocolate fácil de fazer para acompanhar o café da tarde.',
                        '45 mins',
                        'assets/images/bolo_de_cenoura.jpg', // Insira a imagem correta no local certo
                      ),
                    ),
                    _buildReceitaCard(
                      'Macarrão premium',
                      'Uma receita simples e rápida de macarrão ao alho e óleo, perfeita para um jantar prático.',
                      '30 mins',
                      'assets/images/macarrao_premium.jpg',
                    ),
                    _buildReceitaCard(
                      'Bife com fritas',
                      'Bife acebolado com batata é um prato clássico e saboroso que combina bifes suculentos grelhados ou fritos.',
                      '30 mins',
                      'assets/images/bife_fritas.jpg',
                    ),
                    _buildReceitaCard(
                      'Lasanha',
                      'Uma receita simples e rápida de lasanha à bolonhesa para qualquer ocasião.',
                      '60 mins',
                      'assets/images/lasanha.jpg',
                    ),
                    _buildReceitaCard(
                      'Escondidinho',
                      'O Escondidinho de Carne é um prato brasileiro feito com uma camada de carne moída bem temperada, coberta com purê de mandioca (ou batata), finalizado com queijo gratinado.',
                      '40 mins',
                      'assets/images/escondidinho.jpg',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Função para criar os cards de receita
  Widget _buildReceitaCard(String titulo, String descricao, String tempo, String imagem) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagem,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    descricao,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.timer, size: 16, color: Colors.red),
                      SizedBox(width: 5),
                      Text(
                        tempo,
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
