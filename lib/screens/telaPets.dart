import 'package:flutter/material.dart';
import '../screens/telaHomePage.dart'; // Importando as páginas que criamos
import '../screens/telaHistorico.dart';

class PerfilPet extends StatefulWidget {
  const PerfilPet({super.key});

  @override
  State<PerfilPet> createState() => _PerfilPetState();
}

class _PerfilPetState extends State<PerfilPet> {
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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
                    child: Text(
                      'Meu Pet',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(
                            color: Color(0xFF54BA9A),
                            width: 0.2,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(0),
                            child: Image.asset(
                              'lib/assets/imgs/Xiao.png',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Xiao',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Gato | SRD | 3 anos | Dieta Mista',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
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
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PerfilPet(),
    debugShowCheckedModeBanner: false,
  ));
}
