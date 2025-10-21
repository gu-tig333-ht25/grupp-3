import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:template/providers/theme_provider.dart';
import 'package:template/widgets/navigation_bar.dart';
import 'package:template/screens/login.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          children: [
            if (user != null) ...[
              const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFDEE1FF),
                backgroundImage: AssetImage('assets/default_profile.png'),
              ),
              const SizedBox(height: 10),
              Text(
                "Inloggad som: ${user.email}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
            ],

            // Mörkt läge växling
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Mörkt läge", style: TextStyle(fontSize: 16)),
                Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Logga in / Logga ut knapp
            ElevatedButton(
              onPressed: () async {
                if (user != null) {
                  await FirebaseAuth.instance.signOut();
                  if (!mounted) return;
                  setState(() {}); // uppdatera vyn
                } else {
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3F1FC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              child: Text(
                user != null ? "Logga ut" : "Logga in",
                style: const TextStyle(
                  color: Color(0xFF444444),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(currentPageIndex: 2),
    );
  }
}
