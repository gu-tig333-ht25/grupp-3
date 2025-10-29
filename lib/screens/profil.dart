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
  ImageProvider getProfileImage(String? photoUrl) {
    if (photoUrl != null && photoUrl.startsWith('http')) {
      return NetworkImage(photoUrl);
    } else {
      return const AssetImage('assets/default_profile.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[400]!;

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
              CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFFDEE1FF),
                backgroundImage: getProfileImage(user.photoURL),
              ),
              const SizedBox(height: 10),
              Text(
                "Inloggad som: ${user.email}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
            ],
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1.3),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
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
            ),
            const SizedBox(height: 40),
            OutlinedButton(
              onPressed: () async {
                if (user != null) {
                  await FirebaseAuth.instance.signOut();
                  if (!mounted) return;
                  setState(() {});
                } else {
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: borderColor, width: 1.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                backgroundColor: isDark
                    ? const Color(0xFF1E1E1E)
                    : const Color(0xFFF8F8F8),
              ),
              child: Text(
                user != null ? "Logga ut" : "Logga in",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
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
