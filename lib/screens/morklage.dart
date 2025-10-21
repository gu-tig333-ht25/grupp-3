import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class MorklageScreen extends StatelessWidget {
  const MorklageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mörkläge', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _themeButton(
              context,
              label: 'Av',
              isSelected: themeProvider.themeMode == ThemeMode.light,
              onPressed: () => themeProvider.toggleTheme(ThemeMode.light),
            ),
            _themeButton(
              context,
              label: 'På',
              isSelected: themeProvider.themeMode == ThemeMode.dark,
              onPressed: () => themeProvider.toggleTheme(ThemeMode.dark),
            ),
            _themeButton(
              context,
              label: 'System',
              isSelected: themeProvider.themeMode == ThemeMode.system,
              onPressed: () => themeProvider.toggleTheme(ThemeMode.system),
            ),
          ],
        ),
      ),
    );
  }

  Widget _themeButton(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    final color = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color, width: 1.5),
          backgroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? color : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
