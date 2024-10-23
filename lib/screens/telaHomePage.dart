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

  // Firebase
  late double temperatura = 0.0;
  late double peso = 0.0;
  late double variacaoPeso = 0.0;
  late int horaCompleta = 0;

  final DatabaseReference dataBase = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();

    // Listener para o valor do peso
    dataBase.child('ESP/Peso').onValue.listen((event) {
      final pesoValue = event.snapshot.value;
      if (pesoValue != null && mounted) {
        setState(() {
          peso =
              (pesoValue is int) ? pesoValue.toDouble() : pesoValue as double;
        });
      }
    });

    // Listener para o valor da temperatura
    dataBase.child('ESP/Temperatura').onValue.listen((event) {
      final temperaturaValue = event.snapshot.value;
      if (temperaturaValue != null && mounted) {
        setState(() {
          temperatura = (temperaturaValue is int)
              ? temperaturaValue.toDouble()
              : temperaturaValue as double;
        });
      }
    });

    // Listener para a variação de peso
    dataBase.child('ESP/VariacaoPeso').onValue.listen((event) {
      final variacaoPesoValue = event.snapshot.value;
      if (variacaoPesoValue != null && mounted) {
        setState(() {
          variacaoPeso = (variacaoPesoValue is int)
              ? variacaoPesoValue.toDouble()
              : variacaoPesoValue as double;
        });
      }
    });

    // Listener para o valor da hora completa
    dataBase.child('ESP/HoraCompleta').onValue.listen((event) {
      final horaCompletaValue = event.snapshot.value;
      if (horaCompletaValue != null && mounted) {
        setState(() {
          horaCompleta = horaCompletaValue as int;
        });
      }
    });
  }

  @override
  void dispose() {
    // Remover os listeners para evitar problemas quando o widget for desmontado
    dataBase.child('ESP/Peso').onValue.drain();
    dataBase.child('ESP/Temperatura').onValue.drain();
    dataBase.child('ESP/VariacaoPeso').onValue.drain();
    dataBase.child('ESP/HoraCompleta').onValue.drain();
    super.dispose();
  }

  // Função para alterar a aba selecionada
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    HomeContent(), // Tela da aba "Início"
    History(), //tela de registros
    HomeContent(), // Substitua pelo widget da página de consumo
    PerfilPet(), // Substitua pelo widget da página de pets
    HomeContent(), // Substitua pelo widget da página do usuário
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
      body: Center(
        child: _widgetOptions
            .elementAt(_selectedIndex), // Exibe o conteúdo da aba selecionada
      ),
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
  @override
  Widget build(BuildContext context) {
    final _MainScreenState = context.findAncestorStateOfType<_HomePageState>();

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
                          infoCard('${_MainScreenState!.peso}l', 'Reservatório',
                              Color(0xFF15427A)),
                          SizedBox(width: 6),
                          infoCard('${_MainScreenState!.temperatura}°',
                              'Temperatura da Água', Color(0xFF15427A)),
                          SizedBox(width: 6),
                          infoCard('${_MainScreenState!.horaCompleta}',
                              'Último Consumo', Color(0xFF54BA9A)),
                          SizedBox(width: 6),
                          infoCard('${_MainScreenState!.variacaoPeso}ml',
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
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Acompanhe a hidratação de seu pet!',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF57636C),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.keyboard_arrow_left_rounded, color: Colors.grey),
                SizedBox(width: 16),
                Container(
                  width: 267,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text('Gráfico de Barras Aqui'),
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
