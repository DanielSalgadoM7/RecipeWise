import 'package:flutter/material.dart';

class Dicas extends StatelessWidget {
  final String texto;
  const Dicas(this.texto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DICAS")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Dicas para Cozinha
            ExpansionTile(
              title: Container(
                padding: EdgeInsets.all(10),
                color: Colors.red,
                child: Text(
                  "Dicas para Cozinha",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    "A cozinha é o coração da casa, e para que tudo funcione bem durante o preparo das receitas, é essencial manter um ambiente organizado e funcional. Aqui estão algumas dicas para garantir que você tenha uma cozinha eficiente e bem equipada:\n\n"
                        "- POSICIONAMENTO: Organize suas ferramentas de cozinha, como facas, colheres de pau, espátulas e medidores, em um local de fácil acesso. Use organizadores ou gavetas específicas para isso.\n\n"
                        "- PROXIMIDADE: Alguns utensílios básicos, como tesoura de cozinha, ralador, peneira, e descascadores, são indispensáveis e devem estar facilmente acessíveis.\n\n"
                        "- LAVAGEM: Evite acumular louça enquanto cozinha. Lave os utensílios conforme termina de usá-los para garantir uma cozinha sempre limpa e organizada.\n\n"
                        "- INVESTIMENTO: Facas afiadas, panelas e frigideiras de qualidade fazem toda a diferença no processo de preparação dos alimentos. Prefira utensílios duráveis e resistentes.\n\n",
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
                  "Dicas sobre Organização e Preparação",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    "Antes de começar a cozinhar, um bom planejamento e organização podem fazer toda a diferença. Aqui estão algumas dicas para otimizar o seu tempo e garantir uma cozinha sem estresse:\n\n"
                        "- PREPARAÇÃO: Lave, corte, meça e separe todos os ingredientes antes de iniciar o preparo. Isso economiza tempo e evita correria no meio da receita.\n\n"
                        "- LIMPEZA GERA PRATICIDADE: Organize os utensílios e ingredientes de maneira que fiquem facilmente acessíveis durante o preparo, para evitar a bagunça e o caos na hora da receita.\n\n"
                        "- ORGANIZAR: Para ingredientes como temperos, ervas e especiarias, use tigelas pequenas ou potes para que fiquem bem visíveis e de fácil acesso.\n\n"
                        "- SEPARAR: Por exemplo, se a receita requer uma frigideira, uma panela e um ralador, organize esses utensílios antes de começar, de acordo com as etapas do preparo.\n\n",
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
                  "Dicas para Iniciantes",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    "Se você está começando a cozinhar agora, não se preocupe! Todos começam de algum lugar. Aqui estão algumas dicas que vão te ajudar a ter mais confiança na cozinha e a evitar erros comuns:\n\n"
                        "- RECEITAS SIMPLES E PRÁTICAS: Ao começar, prefira receitas que exijam poucos ingredientes e etapas simples. Isso ajuda a ganhar experiência e confiança sem se sentir sobrecarregado.\n\n"
                        "- NÃO TER MEDO DE ERRAR: Cozinhar é uma habilidade que exige prática. Se algo der errado, não desanime. O importante é aprender com os erros e continuar tentando!\n\n"
                        "- SEGUIR A RECEITA: No começo, é importante seguir as instruções de maneira precisa. Isso te ajuda a entender o processo e a técnica por trás das receitas.\n\n"
                        "- UTENSÍLIOS CORRETOS: Comece com utensílios simples, como panelas e facas de boa qualidade, para evitar frustrações. Ferramentas de boa qualidade tornam o processo de cozinhar mais fácil e seguro.\n\n",
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
                  "Dicas para Cozinheiros Avançados",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    "Se você já tem experiência na cozinha e está pronto para levar seus pratos a um novo nível, aqui estão algumas dicas para você aprimorar suas habilidades e técnicas:\n\n"
                        "- TÉCNICAS E INGREDIENTES NOVOS: Não tenha medo de explorar novas técnicas, como sous-vide, defumação ou confit, ou mesmo ingredientes exóticos. Isso vai agregar novos sabores e texturas aos seus pratos.\n\n"
                        "- AJUSTAR TEMPEROS COM SUA EXPERIÊNCIA: Aprenda a balancear temperos e especiarias para criar sabores complexos. A mistura certa de sal, pimenta, ervas frescas e secas pode transformar um prato simples em uma obra-prima.\n\n"
                        "- APRESENTAÇÕES CRIATIVAS: Cozinheiros avançados sabem que a aparência do prato é tão importante quanto o sabor. Experimente apresentações criativas e use técnicas como emulsificação, espumas e texturização de alimentos.\n\n"
                        "- VINHOS E HARMONIZAÇÕES: Se você gosta de vinhos, aprenda sobre harmonização de vinhos com os pratos. Isso é um grande diferencial para cozinheiros avançados e agregará um toque profissional ao seu trabalho.\n\n",
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
                  "Dicas Gerais",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              children: [
                ListTile(
                  title: Text(
                    "Algumas dicas gerais podem ser aplicadas a qualquer cozinheiro, independentemente do nível de experiência. Aqui estão algumas sugestões para melhorar seu desempenho e garantir que a cozinha seja sempre um lugar agradável:\n\n"
                        "- LEIA A RECEITA POR COMPLETO: Isso garante que você tenha todos os ingredientes e utensílios necessários à mão, e evita surpresas no meio do preparo.\n\n"
                        "- LIMPEZA: Manter a cozinha limpa e organizada durante o processo de preparo é essencial para evitar bagunça e facilitar o trabalho.\n\n"
                        "- PACIÊNCIA E APROVEITAMENTO: Cozinhar deve ser prazeroso. Aproveite cada passo e explore novos sabores. Não apresse o processo, especialmente em pratos mais elaborados.\n\n"
                        "- COMUNICAÇÃO: Se estiver cozinhando com outras pessoas, a comunicação é crucial. Divida as tarefas, como cortar, mexer e preparar os ingredientes, para garantir um fluxo de trabalho harmonioso.\n\n",
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
