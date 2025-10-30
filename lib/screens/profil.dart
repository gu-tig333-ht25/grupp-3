import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/providers/theme_provider.dart';
import 'package:template/providers/auth_provider.dart';
import 'package:template/widgets/navigation_bar.dart';
import 'package:template/screens/login.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  ImageProvider getProfileImage(String? photoUrl) {
    if (photoUrl != null && photoUrl.startsWith('http')) {
      return NetworkImage(photoUrl);
    } else {
      return const AssetImage('assets/default_profile.png');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();

    final isDark = themeProvider.isDarkMode;
    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[400]!;
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(title: const Text("Profil"), centerTitle: true),
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
                "Inloggad som: ${user.email ?? 'Okänd användare'}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
            ] else ...[
              const Icon(Icons.account_circle, size: 80, color: Colors.grey),
              const SizedBox(height: 10),
              const Text("Ingen användare inloggad", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 30),
            ],

            // Theme toggle
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
                    onChanged: themeProvider.toggleTheme,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            OutlinedButton(
              onPressed: () async {
                if (user != null) {
                  await context.read<AuthProvider>().logout();
                } else {
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
                backgroundColor:
                    isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF8F8F8),
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
