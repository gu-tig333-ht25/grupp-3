import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notiser.dart';
import 'morklage.dart';
import 'login.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

 @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (user != null) ...[
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 45,
                backgroundImage: user.photoURL != null
                    ? NetworkImage(user.photoURL!)
                    : const NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
              ),
              const SizedBox(height: 12),
              Text(
                'Inloggad som',
                style: TextStyle(color: Colors.grey[700], fontSize: 14),
              ),
              Text(
                user.email ?? '',
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 24),
            ],
            _menuButton(
              context,
              icon: Icons.notifications_outlined,
              text: 'Notiser',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotiserScreen()),
                );
              },
            ),
            _menuButton(
              context,
              icon: Icons.dark_mode_outlined,
              text: 'Mörkläge',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MorklageScreen()),
                );
              },
            ),
            _menuButton(
              context,
              icon: user != null
                  ? Icons.logout_outlined
                  : Icons.login_outlined,
              text: user != null ? 'Logga ut' : 'Logga in',
              onPressed: () async {
                if (user != null) {
                  await FirebaseAuth.instance.signOut();
                  
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfilScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(
    BuildContext context, {
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(icon, color: Theme.of(context).colorScheme.primary),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
