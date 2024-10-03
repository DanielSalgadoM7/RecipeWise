// Atualizando o nome da classe para BoloDeCenoura
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Para abrir links externos

class BoloDeCenoura extends StatelessWidget {  // Corrigido aqui
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bolo de Cenoura com Chocolate'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagem da receita
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/images/bolo_de_cenoura.jpg',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Título da receita
              Text(
                'Bolo de Cenoura com Chocolate',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // Ingredientes
              Text(
                'Ingredientes:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '• 1/2 xícara (chá) de óleo\n'
                    '• 4 ovos\n'
                    '• 2 e 1/2 xícaras (chá) de farinha de trigo\n'
                    '• 3 cenouras médias raladas\n'
                    '• 2 xícaras (chá) de açúcar\n'
                    '• 1 colher (sopa) de fermento em pó',
              ),
              SizedBox(height: 16),

              // Modo de preparo
              Text(
                'Modo de Preparo:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1. Em um liquidificador, adicione a cenoura, os ovos e o óleo, depois misture.\n'
                    '2. Acrescente o açúcar e bata novamente por 5 minutos.\n'
                    '3. Em uma tigela ou na batedeira, adicione a farinha de trigo e depois misture novamente.\n'
                    '4. Acrescente o fermento e misture lentamente com uma colher.\n'
                    '5. Asse em um forno preaquecido a 180°C por aproximadamente 40 minutos.\n',
              ),
              SizedBox(height: 16),

              // Vídeo do YouTube (botão para abrir no navegador)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    const url = 'https://www.youtube.com/shorts/iHHwkmlzE14';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Não foi possível abrir o link: $url';
                    }
                  },
                  icon: Icon(Icons.play_circle_fill),
                  label: Text('Assista ao Tutorial'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
