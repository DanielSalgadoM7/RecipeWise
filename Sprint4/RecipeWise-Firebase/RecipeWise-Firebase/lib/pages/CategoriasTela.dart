import 'package:flutter/material.dart';

class Categorias extends StatelessWidget {
  final String texto;
  const Categorias(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CATEGORIAS")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dicas para Cozinha
            ExpansionTile(
              title: Container(
                padding: EdgeInsets.all(10),
                color: Colors.red,
                child: Text(
                  "DOCES",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    "Uma comida doce é caracterizada por um sabor agradável e adocicado, geralmente causado pela presença de açúcares como sacarose, frutose ou glicose. Esses açúcares interagem com as papilas gustativas da língua, proporcionando uma sensação agradável e prazerosa.:\n\n"
                        "- SABOR: Adocicado, suave e agradável ao paladar.\n\n"
                        "- TEXTURA: Pode variar de macia e cremosa a crocante e firme, dependendo do ingrediente principal e do método de preparo.\n\n"
                        "- AROMA: Agradável e convidativo, com notas de frutas, caramelo, baunilha ou outros ingredientes doces.\n\n"
                        "- COR: Geralmente clara, como branco, amarelo ou tons pastéis, mas pode variar de acordo com os ingredientes utilizados.\n\n\n"
                    ,

                    style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

// Dicas sobre Organização e Preparação
            ExpansionTile(
              title: Container(
                padding: EdgeInsets.all(10),
                color: Colors.red,
                child: Text(
                  "SALGADOS",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    "Uma comida salgada é caracterizada por um sabor que estimula as papilas gustativas e provoca a sensação de salinidade. Esse sabor é fundamental para o paladar humano e está presente em uma grande variedade de alimentos:\n\n"
                        "- SABOR: Salgado, podendo variar de levemente salgado a muito salgado, dependendo dos ingredientes e da quantidade de sal utilizada.\n\n"
                        "- TEXTURA: Pode ser variada, desde macia e cremosa até crocante e firme, dependendo do tipo de alimento e do método de preparo.\n\n"
                        "- AROMA: Geralmente mais intenso e complexo do que os alimentos doces, podendo apresentar notas de alho, cebola, ervas, especiarias e outros ingredientes salgados.\n\n"
                        "- COR: A cor dos alimentos salgados é bastante variada e depende dos ingredientes utilizados.\n\n",
                    style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

// Dicas para Iniciantes
            ExpansionTile(
              title: Container(
                padding: EdgeInsets.all(10),
                color: Colors.red,
                child: Text(
                  "AZEDOS",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    "O sabor azedo é uma das sensações gustativas básicas, caracterizado por uma acidez que estimula a salivação e pode ser refrescante ou aguçante. Essa sensação é frequentemente associada a alimentos cítricos e fermentados.:\n\n"
                        "- SABOR: Ácido, agridoce ou azedinho, podendo variar em intensidade.\n\n"
                        "- AROMA: Cítrico, frutado ou fermentado, dependendo do ingrediente principal.\n\n"
                        "- TEXTURA: Pode variar bastante, desde líquidos (sucos) até sólidos (frutas).\n\n"
                        "- COR: Geralmente clara, como amarelo, verde ou laranja, mas pode variar com o tipo de alimento.\n\n",
                    style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

// Dicas para Cozinheiros Avançados
            ExpansionTile(
              title: Container(
                padding: EdgeInsets.all(10),
                color: Colors.red,
                child: Text(
                  "AMARGOS",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    "O sabor amargo é uma das sensações gustativas básicas, muitas vezes associado a alimentos que contêm compostos como alcaloides e taninos. Embora seja menos apreciado por muitos, o amargor desempenha um papel importante na culinária, adicionando complexidade e profundidade aos pratos.:\n\n"
                        "- SABOR: Intenso e persistente, com uma sensação de adstringência na boca.\n\n"
                        "- AROMA: Pode ser herbal, floral, terroso ou até mesmo medicinal.\n\n"
                        "- TEXTURA: Geralmente firme, mas pode variar dependendo do alimento.\n\n"
                        "- COR: Pode ser verde escura, marrom ou roxa, mas também pode ser encontrada em alimentos de outras cores.\n\n",
                    style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

// Dicas Gerais
            ExpansionTile(
              title: Container(
                padding: EdgeInsets.all(10),
                color: Colors.red,
                child: Text(
                  "PICANTES",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    "O sabor picante é uma sensação gustativa intensa e complexa, geralmente associada à presença de capsaicina, um composto encontrado em pimentas. Essa sensação pode variar desde um leve ardor até um calor intenso e duradouro:\n\n"
                        "- SABOR: Ardente, quente, picante, podendo variar em intensidade.\n\n"
                        "- AROMA: Forte e característico, com notas de pimenta, especiarias e ervas.\n\n"
                        "- TEXTURA: Pode variar, dependendo do ingrediente principal.\n\n"
                        "- COR: Geralmente vermelha ou laranja, devido à presença de pimentas, mas pode variar.\n\n",
                    style: TextStyle(fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
