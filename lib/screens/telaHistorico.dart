import 'package:app_login/databaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final database = FirebaseDatabase.instance.reference();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<Map<String, String>> updates = [];

  // Variáveis para armazenar os valores anteriores
  String? _lastHoraCompleta;
  String? _lastVariacaoPeso;

  @override
  void initState() {
    super.initState();

    // Carrega o histórico salvo localmente
    _loadHistory();

    // Ouve as mudanças no Firebase e atualiza a lista
    database.child('ESP').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final String variacaoPeso = data['VariacaoPeso'] ?? '0.0ml';
        final String dataHoraCompleta = data['DataHoraCompleta'] ?? 'Sem data';
        final String horaCompleta = data['HoraCompleta'] ?? 'Sem horário';
        final String peso = data['Peso']?.toString() ?? '0.0l';

        // Verifica se ambos, HoraCompleta e VariacaoPeso, foram atualizados
        if (horaCompleta != _lastHoraCompleta &&
            variacaoPeso != _lastVariacaoPeso) {
          final newData = {
            'variacaoPeso': variacaoPeso + 'ml',
            'dataHoraCompleta': dataHoraCompleta,
            'horaCompleta': horaCompleta,
            'peso': peso + 'l',
          };

          setState(() {
            updates.insert(0, newData);
            _listKey.currentState?.insertItem(0);

            // Atualiza os últimos valores armazenados
            _lastHoraCompleta = horaCompleta;
            _lastVariacaoPeso = variacaoPeso;

            // Salva o novo dado no banco de dados local
            _saveToLocalDatabase(newData);
          });
        }
      }
    });
  }

  // Função para salvar os dados localmente no SQLite
  void _saveToLocalDatabase(Map<String, String> newData) async {
    await DatabaseHelper.instance.insertHistory(newData);
    print('Dados salvos localmente com sucesso!');
  }

  // Função para carregar o histórico salvo no banco de dados local
  Future<void> _loadHistory() async {
    final historyList = await DatabaseHelper.instance.fetchAllHistory();
    setState(() {
      updates = historyList
          .map<Map<String, String>>((entry) => {
                'variacaoPeso': entry['variacaoPeso'].toString(),
                'dataHoraCompleta': entry['dataHoraCompleta'].toString(),
                'horaCompleta': entry['horaCompleta'].toString(),
                'peso': entry['peso'].toString(),
              })
          .toList();

      // Opcional: Adiciona todos os itens carregados ao AnimatedList
      for (int i = 0; i < updates.length; i++) {
        _listKey.currentState?.insertItem(i);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Histórico',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Acompanhamento detalhado da ingestão:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 16),

              // AnimatedList para exibir a lista com animação
              Expanded(
                child: AnimatedList(
                  key: _listKey, // Chave da lista animada
                  initialItemCount: updates.length, // Número inicial de itens
                  itemBuilder: (context, index, animation) {
                    final update = updates[index];
                    return _buildAnimatedItem(
                        update.cast<String, String>(), animation, index);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // Função para construir o item animado
  Widget _buildAnimatedItem(
      Map<String, String> update, Animation<double> animation, int index) {
    return SizeTransition(
      sizeFactor: animation, // Animação de crescimento
      child: _buildInfoContainer(
        update['variacaoPeso'] ?? '0.0ml',
        update['dataHoraCompleta'] ?? 'Sem data',
        update['horaCompleta'] ?? 'Sem horário',
        update['peso'] ?? '0.0l',
      ),
    );
  }

  // Função para construir o Container com as variáveis atualizadas
  Widget _buildInfoContainer(String variacaoPeso, String dataHoraCompleta,
      String horaCompleta, String peso) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0), // Espaço entre os containers
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1B4D7D),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'lib/assets/imgs/Xiao.png',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Xiao bebeu: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      TextSpan(
                        text: variacaoPeso,
                        style: TextStyle(
                          color: Color(0xFF54BA9A),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      TextSpan(
                        text: '\nna última vez.',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  dataHoraCompleta,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                horaCompleta,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  peso,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
