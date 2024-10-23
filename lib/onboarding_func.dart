import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

mixin Func {
  // Email & Password Authentication - Sign in
  Future<UserCredential?> signInWithEmailAndPassword(
    String emailController, String passwordController) async {
  try {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController,
      password: passwordController,
    );
  } on FirebaseAuthException catch (e) {
    // Adicione tratamento para exceções
    print('Erro durante o login: ${e.message}');
    return null;  // Caso ocorra erro, retorne null
  }
}

  // Email & Password Authentication — Sign up
  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }
}
