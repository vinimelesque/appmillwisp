import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import '../auth_service.dart'; // Importa o serviço de autenticação
import 'myapp.dart'; // Importa o MyApp correto
import 'package:firebase_auth/firebase_auth.dart'; // Para o User

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garante que o Flutter esteja inicializado antes do Firebase
  await Firebase.initializeApp(); // Inicializa o Firebase

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(), // Cria a instância do AuthService
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().user, // Ouve mudanças no estado de autenticação
          initialData: null, // Inicializa o usuário como nulo
        ),
      ],
      child: const MyApp(), // Carrega o app
    ),
  );
}