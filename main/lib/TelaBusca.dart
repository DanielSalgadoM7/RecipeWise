import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SegundaTela extends StatelessWidget {
  final String valor;

  SegundaTela({required this.valor});

  void _abrirLink() async {
    const url = 'https://receitas.globo.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Receitas"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "A receita buscada foi: $valor",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _abrirLink,
              child: Text("Abrir $valor"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
