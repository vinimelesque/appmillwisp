import 'package:flutter/material.dart';
import '../screens/telaHomePage.dart'; // Importando as páginas que criamos
import '../screens/telaHistorico.dart';

class TelaConsumo extends StatefulWidget {
  const TelaConsumo({super.key});

  @override
  State<TelaConsumo> createState() => _TelaConsumoState();
}

class _TelaConsumoState extends State<TelaConsumo> {
  int _selectedIndex = 0;

  get scaffoldKey => null; // Índice da aba selecionada

  // Função para alterar a aba selecionada e navegar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Adicione mais telas conforme necessário para os outros índices
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.all(6.0), // Adicionando padding nas bordas
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Alinha os itens à esquerda
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Consumo',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Ingestão graficada:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: Container(
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
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estatísticas de Xiao',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF14181B),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Acompanhe a hidratação de Xiao!',
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
                              Icon(Icons.keyboard_arrow_left_rounded,
                                  color: Colors.grey),
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
                              Icon(Icons.keyboard_arrow_right_rounded,
                                  color: Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
                    child: Container(
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
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Consumo Mensal',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF14181B),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Acompanhe a hidratação de Ting!',
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
                              Icon(Icons.keyboard_arrow_left_rounded,
                                  color: Colors.grey),
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
                              Icon(Icons.keyboard_arrow_right_rounded,
                                  color: Colors.grey),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TelaConsumo(),
    debugShowCheckedModeBanner: false,
  ));
}
