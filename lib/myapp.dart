import 'package:app_login/screens/telaHistorico.dart';
import 'package:flutter/material.dart';
import 'screens/telaLogin.dart';
import 'screens/telaCadastro.dart'; // Certifique-se de que o nome do arquivo está correto
import 'screens/telaHomePage.dart';
import 'screens/telaSplashScreen.dart';
import 'screens/telaPets.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => Splash(),
        '/perfilpet': (context) => PerfilPet(),
        '/homepage': (context) => HomePage(),
        '/login': (context) => const Login(),
        '/cadastro': (context) => const Cadastro(),
        '/history': (context) => const History(),
      },
    );
  }
}


