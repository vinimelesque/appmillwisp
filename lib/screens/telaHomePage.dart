import 'package:app_login/screens/telaConsumo.dart';
import 'package:app_login/screens/telaUsuario.dart';
import '../screens/telaHistorico.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Importação do Firebase
import '../screens/telaPets.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Índice da aba selecionada

  final DatabaseReference dataBase = FirebaseDatabase.instance.reference();

  // Função para alterar a aba selecionada
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    HomeContent(), // Tela da aba "Início"
    History(), //tela de registros
    TelaConsumo(), // Substitua pelo widget da página de consumo
    PerfilPet(), // Substitua pelo widget da página de pets
    TelaPerfil(), // Substitua pelo widget da página do usuário
  ];

  get scaffoldKey => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false, // Isso remove a seta de voltar
        title: Align(
          alignment: Alignment.center,
          child: Image.asset(
            'lib/assets/imgs/Logo.png',
            width: 100,
            height: 65,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _widgetOptions
          .elementAt(_selectedIndex), // Exibe o conteúdo da aba selecionada
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Fixa a barra com as opções
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Registros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Consumo',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Pets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuário',
          ),
        ],
        currentIndex: _selectedIndex, // Índice da aba selecionada
        selectedItemColor: Colors.orange, // Cor para a aba selecionada
        unselectedItemColor: Colors.grey, // Cor para as abas não selecionadas
        onTap: _onItemTapped, // Função chamada quando uma aba é tocada
      ),
    );
  }
}

// Conteúdo da HomePage (aba "Início")
class HomeContent extends StatelessWidget {
  final DatabaseReference database = FirebaseDatabase.instance.reference();

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir a URL: $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção "Última Atualização"
            Container(
              width: double.infinity,
              height: 194,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 3,
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Última atualização',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 113,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          buildRealtimeDataCard(
                              'Peso', ' l', 'Reservatório', Color(0xFF15427A)),
                          buildRealtimeDataCard('Temperatura', '°',
                              'Temperatura da Água', Color(0xFF15427A)),
                          buildRealtimeDataCard('HoraCompleta', '',
                              'Último Consumo', Color(0xFF54BA9A)),
                          buildRealtimeDataCard('VariacaoPeso', 'ml',
                              'Quantidade ingerida', Color(0xFF54BA9A)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Aqui estava o fechamento incorreto "Column",
            // Substituí por SizedBox(height: 16),
            SizedBox(height: 16),
            // Seção com o link
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fique ligado!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    const url =
                        'https://millwisp.site'; // Substitua pela URL desejada
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Não foi possível abrir o link: $url';
                    }
                  },
                  child: Image.asset(
                    'lib/assets/imgs/Homeimage.png', // Substitua pela imagem desejada
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Seção "Meus Pets"
            buildPetsSection(context),
            SizedBox(height: 16),
            // Seção "Estatísticas"
            buildStatisticsSection(context),
          ],
        ),
      ),
    );
  }

  Widget buildRealtimeDataCard(
      String key, String unit, String label, Color color) {
    return StreamBuilder(
      stream: database.child('ESP/$key').onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final value = snapshot.data!.snapshot.value;
          var displayValue =
              (value != null) ? value.toString() + unit : '0$unit';

          // Verifica se é o campo 'HoraCompleta' e ajusta o formato
          // Verifica se a chave é 'VariacaoPeso' e ajusta o formato para uma casa decimal
          if (key == 'VariacaoPeso' && value != null) {
            double variacaoPeso = double.tryParse(value.toString()) ?? 0.0;
            displayValue = variacaoPeso.toStringAsFixed(1) +
                unit; // Apenas uma casa decimal

            // Verifica se a chave é 'HoraCompleta' e ajusta o formato para exibir horas e minutos
          } else if (key == 'HoraCompleta' && value != null) {
            String horaCompleta = value.toString();

            // Supondo que o formato seja algo como 'HH:MM:SS'
            List<String> partes = horaCompleta.split(':');
            if (partes.length >= 2) {
              // Mantém apenas as horas e os minutos
              displayValue = '${partes[0]}:${partes[1]}';
            }

            // Se for outra chave, usa o valor normalmente
          } else if (value != null) {
            displayValue = value.toString() + unit;
          }

          // Inicializa a cor padrão
          Color cardColor = color;

          // Verifica se o valor do peso é maior ou igual a 0.5 e altera a cor
          if (key == 'Peso' && value != null) {
            double peso = double.tryParse(value.toString()) ?? 0.0;
            if (peso > 0.5) {
              cardColor = Color(0xFF15427A); // Cor para o peso >= 0.5
            } else {
              cardColor = Colors.red; // Cor para o peso S< 0.5
            }
          }

          return infoCard(displayValue, label, cardColor);
        } else {
          return infoCard('0$unit', label,
              color); // Valor padrão enquanto os dados não carregam
        }
      },
    );
  }

  // Widget de cartão de informação
  Widget infoCard(String value, String label, Color color) {
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(0xFFE0E3E7),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18, // Tamanho da fonte ajustado para o valor
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10, // Tamanho da fonte ajustado para o rótulo
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Função para construir a seção de informações
  Widget buildInfoSection(BuildContext context,
      {required String title, required String image}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF14181B),
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  image,
                  width: 320,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Função para construir a seção "Meus Pets"
  Widget buildPetsSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Meus Pets',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF14181B),
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Consultar dados do meu Pet',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF57636C),
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF54BA9A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Exemplo de como adicionar a navegação ao clicar na imagem
                          GestureDetector(
                            onTap: () {
                              // Atualiza o índice para exibir a tela `PerfilPet` (índice 3 na lista _widgetOptions)
                              final homePageState = context
                                  .findAncestorStateOfType<_HomePageState>();
                              homePageState?.setState(() {
                                homePageState._selectedIndex =
                                    3; // Índice correspondente a PerfilPet() em _widgetOptions
                              });
                            },
                            child: Image.asset(
                              'lib/assets/imgs/Xiao.png',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Xiao',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Função para construir a seção "Estatísticas"
  Widget buildStatisticsSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estatísticas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF14181B),
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Acompanhe a hidratação de seu pet!',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF57636C),
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.keyboard_arrow_left_rounded, color: Colors.grey),
                SizedBox(width: 16),
                Expanded(
                  // Adiciona o Expanded aqui para o gráfico se ajustar ao espaço disponível
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text('Gráfico de Barras Aqui'),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Icon(Icons.keyboard_arrow_right_rounded, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}
