import 'package:app_login/onboarding_func.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/telaLogin.dart';
import '../auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> with Func {
  late TextEditingController _nameController;
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  late TextEditingController _emailCheckController;
  late TextEditingController _numberController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordCheckController;
  bool _passwordVisible = false; // Inicialize como falso
  bool _passwordCheckVisible = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _userNameController = TextEditingController();
    _emailController = TextEditingController();
    _emailCheckController = TextEditingController();
    _numberController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordCheckController = TextEditingController();
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
                'Registrar Usuário',
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
                    'Caso você já tenha uma conta,',
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
                        MaterialPageRoute(builder: (context) => Login()),
                      ); // Ação para criar conta
                    },
                    child: Text(
                      'clique aqui para entrar nela!',
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
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Digite seu nome',
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
              SizedBox(height: 5 * fem),
              TextField(
                controller: _userNameController,
                decoration: InputDecoration(
                  labelText: 'Nome de usuário',
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
              SizedBox(height: 5 * fem),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
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
              SizedBox(height: 5 * fem),
              TextField(
                controller: _emailCheckController,
                decoration: InputDecoration(
                  labelText: 'Confirme o seu E-mail',
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
              SizedBox(height: 5 * fem),
              TextField(
                controller: _numberController,
                decoration: InputDecoration(
                  labelText: 'Número de telefone',
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
              // Campo para a senha
              TextField(
                controller: _passwordController,
                obscureText:
                    !_passwordVisible, // Controla a visibilidade da senha
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

              SizedBox(height: 6 * fem),
              // Campo para confirmar a senha
              TextField(
                controller: _passwordCheckController,
                obscureText:
                    !_passwordCheckVisible, // Controla a visibilidade da senha de confirmação
                decoration: InputDecoration(
                  labelText: 'Confirme sua senha',
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
                      _passwordCheckVisible
                          ? Icons.visibility
                          : Icons.visibility_off, // Ícone depende do estado
                      size: 5 * fem,
                      color: const Color(0xFF727272),
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordCheckVisible =
                            !_passwordCheckVisible; // Alterna a visibilidade da senha de confirmação
                      });
                    },
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
                      await signUpWithEmailAndPassword(
                          _emailController.text, _passwordController.text);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Now sign in with your new credentials'),
                          ),
                        );
                      }
                    } on FirebaseException catch (e) {
                      if (e.code == 'weak-password') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('A senha é muito fraca, melhore-a.'),
                          ),
                        );
                      } else if (e.code == 'email-already-in-use') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'A conta com o email inserido já existe.'),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Conta criada com sucesso!'),
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Registrar',
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
                  // Ação ao clicar na imagem do Google
                  try {
                    User? user = await AuthService().signInWithGoogle();
                    if (user != null) {
                      print('Login successful: ${user.displayName}');
                      // Aqui você pode navegar para a próxima tela ou fazer outras ações pós-login
                    }
                  } catch (e) {
                    print('Erro ao fazer login com o Google: $e');
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
}
