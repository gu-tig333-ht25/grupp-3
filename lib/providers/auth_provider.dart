import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = credential.user;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception(_mapErrorToMessage(e));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  String _mapErrorToMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return "Ingen användare hittades med den e-posten.";
      case 'wrong-password':
        return "Fel lösenord, försök igen.";
      case 'invalid-email':
        return "Ogiltig e-postadress.";
      default:
        return "Inloggning misslyckades. (${e.code})";
    }
  }
}
