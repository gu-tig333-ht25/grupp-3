import 'package:flutter/material.dart';
import 'package:template/screens/favoriter.dart';
import 'package:template/screens/home.dart';
import 'package:template/screens/profil.dart';

class Navbar extends StatelessWidget {
  final int _currentPageIndex;
  Navbar({super.key, required int currentPageIndex})
    : _currentPageIndex = currentPageIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        if (index == _currentPageIndex) {
          return; // Byta inte till sidan  vi redan är på
        }
        switch (index) {
          case 0: // Home Screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen(),
              ),
            );
            break;
          case 1: // Favoriter
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) => Favoriter()),
            );
            break;
          case 2: // Profil
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ProfilScreen(),
              ),
            );
            break;
        }
      },
      selectedIndex: _currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Stack(
            children: [
              Icon(Icons.home, color: Colors.amber),
              Icon(Icons.home_outlined),
            ],
          ),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Stack(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              Icon(Icons.favorite_outline),
            ],
          ),
          icon: Icon(Icons.favorite_outline),
          label: 'Favoriter',
        ),
        NavigationDestination(
          selectedIcon: Stack(
            children: [
              Icon(Icons.person, color: Colors.amber),
              Icon(Icons.person_outline),
            ],
          ),
          icon: Icon(Icons.person_outline),
          label: 'Profil',
        ),
      ],
    );
  }
}
