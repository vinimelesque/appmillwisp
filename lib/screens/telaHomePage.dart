import 'package:app_login/screens/telaConsumo.dart';
import 'package:app_login/screens/telaUsuario.dart';
import 'package:fl_chart/fl_chart.dart';
import '../screens/telaHistorico.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Importação do Firebase
import '../screens/telaPets.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Adiciona rolagem vertical
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
                          // Exibe o valor do peso recuperado do Firebase
                          buildRealtimeDataCard(
                              'Peso', ' l', 'Reservatório', Color(0xFF15427A)),
                          buildRealtimeDataCard('Temperatura', '°',
                              'Temperatura da Água', Color(0xFF15427A)),
                          buildRealtimeDataCard('HoraCompleta', '',
                              'Último Consumo', Color(0xFF54BA9A)),
                          buildRealtimeDataCard('VariacaoPeso', ' ml',
                              'Quantidade ingerida', Color(0xFF54BA9A)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            // Seção "Fique Ligado!"
            buildInfoSection(
              context,
              title: 'Fique ligado!',
              image: 'lib/assets/imgs/Homeimage.png',
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
          final displayValue =
              (value != null) ? value.toString() + unit : '0$unit';
          return infoCard(displayValue, label, color);
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
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10, // Tamanho da fonte ajustado para o rótulo
                color: Colors.white,
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
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Consulte os pets cadastrados.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF57636C),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.keyboard_arrow_left_rounded, color: Colors.grey),
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
                          Image.asset('lib/assets/imgs/Xiao.png',
                              width: 100, height: 100),
                          SizedBox(width: 16),
                          Text(
                            'Xiao',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_right_rounded, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Função para construir a seção "Estatísticas"
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico em Tempo Real'),
      ),
      body: StreamBuilder(
        stream:
            dataBase.child('ESP/Peso').onValue, // Substitua pela chave desejada
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.snapshot.value;

            // Processa os dados e atualiza os pontos do gráfico
            if (data != null) {
              double peso = double.tryParse(data.toString()) ?? 0.0;

              // Adiciona o novo ponto de dados
              setState(() {
                _dataPoints.add(FlSpot(_dataPoints.length.toDouble(), peso));
              });
            }

            return _buildChart();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  // Função para construir o gráfico
  Widget _buildChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d)),
        ),
        minX: 0,
        maxX: _dataPoints.length > 0 ? _dataPoints.length.toDouble() - 1 : 1,
        minY: 0,
        maxY: _dataPoints.isNotEmpty
            ? _dataPoints.map((e) => e.y).reduce((a, b) => a > b ? a : b)
            : 1,
        lineBarsData: [
          LineChartBarData(
            spots: _dataPoints,
            isCurved: true,
            colors: [Colors.orange],
            barWidth: 3,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              colors: [Colors.orange.withOpacity(0.3)],
            ),
          ),
        ],
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
