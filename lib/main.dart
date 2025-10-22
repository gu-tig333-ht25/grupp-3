import 'package:flutter/material.dart';

// Uppdatera vägarna nedan så de matchar din struktur
import 'screens/home.dart'; // din startsida med knappar
import 'screens/ranta.dart'; // ränta-sidan

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bostadskollen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF0A5C7A),
        useMaterial3: true,
      ),
      home: const HomeScreen(), // ← tillbaka till din ursprungliga startsida
      routes: {
        '/ranta': (_) => const RantaScreen(), // valfritt: named route
      },
    );
  }
}
