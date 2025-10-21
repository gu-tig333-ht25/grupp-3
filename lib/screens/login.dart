import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template/screens/profil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
  setState(() {
    _loading = true;
    _error = null;
  });

  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

  final user = FirebaseAuth.instance.currentUser;
    if (user != null && (user.photoURL == null || user.photoURL!.isEmpty)) {
      await user.updatePhotoURL(
        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
      );
    }

    if (!mounted) return;

    Navigator.of(context).popUntil((route) => route.isFirst);

  } on FirebaseAuthException catch (e) {
    setState(() {
      _error = e.message;
    });
  } finally {
    setState(() {
      _loading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Logga in')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Logga in med testkonto',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-post',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Lösenord',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Logga in'),
            ),
          ],
        ),
      ),
    );
  }
}
