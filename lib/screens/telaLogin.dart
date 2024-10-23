import 'package:app_login/screens/telaHomePage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/telaCadastro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:app_login/onboarding_func.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with Func {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final double fem = MediaQuery.of(context).size.width / 100;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.symmetric(horizontal: 16 * fem, vertical: 1 * fem),
          decoration: const BoxDecoration(
            color: Color(0xFFF3F3F3),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.zero, // Remove completamente as margens
                child: Image.asset(
                  'lib/assets/imgs/Logo.png',
                  width: 48 * fem,
                  height: 48 * fem,
                ),
              ),
              Text(
                'Entrar',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 2 * fem),
              Text(
                'Equipe MillWisp',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4 * fem),
              Column(
                children: [
                  Text(
                    'Caso ainda não tenha registro,',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Cadastro()),
                      ); // Ação para criar conta
                    },
                    child: Text(
                      'clique aqui para criar sua conta!',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: const Color(0xFF15427A), // Cor do texto clicável
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5 * fem),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Digite seu e-mail ou nome de usuário',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    color: const Color(0xFF727272),
                  ),
                  filled: true,
                  fillColor: const Color(0x4D00B3CA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 6 * fem),
              TextField(
                controller: _passwordController,
                obscureText:
                    !_passwordVisible, // Controla se a senha está visível ou não
                decoration: InputDecoration(
                  labelText: 'Senha',
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 15,
                    color: const Color(0xFF727272),
                  ),
                  filled: true,
                  fillColor: const Color(0x4D00B3CA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off, // Ícone depende do estado
                      size: 5 * fem,
                      color: const Color(0xFF727272),
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible =
                            !_passwordVisible; // Alterna a visibilidade da senha
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 2 * fem),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Ação de esquecer senha
                  },
                  child: Text(
                    'Esqueceu a senha?',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: const Color(0xFF727272),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8 * fem),
              SizedBox(
                width: MediaQuery.of(context).size.width /
                    2, // Metade da largura da tela
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: 6 * fem), // Metade do padding vertical
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color(0xFF15427A),
                  ),
                  onPressed: () async {
                    try {
                      final UserCredential? userCredential =
                          await signInWithEmailAndPassword(
                        _emailController.text,
                        _passwordController.text,
                      );

                      if (userCredential != null && context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      } else {
                        // Caso o `userCredential` seja nulo, exibe uma mensagem de erro.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Falha no login. Credenciais inválidas.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      // Tratamento de exceções
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Entrar',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 3 * fem),
              Text(
                'Ou continue com',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: const Color(0xFF727272),
                ),
              ),
              // Diminua ou remova o SizedBox para ajustar o espaço
              SizedBox(
                  height: 5 * fem), // Diminuí o espaço entre o texto e a imagem
              InkWell(
                onTap: () async {
                  try {
                    final UserCredential userCredential =
                        await signInWithGoogle();
                    if (context.mounted) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'User Authentication Error: ${e.toString()}',
                        ),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Container(
                  margin:
                      EdgeInsets.only(bottom: 5 * fem), // Ajuste se necessário
                  child: Image.asset(
                    'lib/assets/imgs/Google.png',
                    width: 6 * fem,
                    height: 6 * fem,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
  // Cria uma instância do GoogleSignIn
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Faz o login com o Google
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  // Verifica se o login foi realizado
  if (googleUser == null) {
    // Se o login falhou, retorna um erro ou null, conforme sua lógica
    throw Exception('Falha ao realizar login com o Google');
  }

  // Obtém os detalhes da autenticação
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Cria uma credencial para o Firebase a partir do token do Google
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Faz o login com as credenciais no Firebase
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
}
