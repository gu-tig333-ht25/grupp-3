import 'package:flutter/material.dart';
import 'package:template/screens/favoriter.dart';
import 'package:template/screens/home.dart';
import 'package:template/screens/profil.dart';

class Navbar extends StatelessWidget {
  final int _currentPageIndex;
  final bool _showSelected;
  Navbar({super.key, required int currentPageIndex, bool showSelected = true})
    : _currentPageIndex = currentPageIndex,
      _showSelected = showSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        if (index == _currentPageIndex && _showSelected) {
          return; // Byta inte till sidan  vi redan är på
        }
        switch (index) {
          case 0: // Home Screen
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen(),
              ),
              (Route<dynamic> route) => false,
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
      indicatorColor: _showSelected
          ? Theme.of(context).navigationBarTheme.indicatorColor
          : const Color.fromARGB(0, 0, 0, 0),
      selectedIndex: _currentPageIndex,
      destinations: <Widget>[
        NavigationDestination(
          selectedIcon: _showSelected
              ? Stack(
                  children: [
                    Icon(Icons.home, color: Colors.amber),
                    Icon(Icons.home_outlined),
                  ],
                )
              : Icon(Icons.home_outlined),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: _showSelected
              ? Stack(
                  children: [
                    Icon(Icons.favorite, color: Colors.red),
                    Icon(Icons.favorite_outline),
                  ],
                )
              : Icon(Icons.favorite_outline),
          icon: Icon(Icons.favorite_outline),
          label: 'Favoriter',
        ),
        NavigationDestination(
          selectedIcon: _showSelected
              ? Stack(
                  children: [
                    Icon(Icons.person, color: Colors.amber),
                    Icon(Icons.person_outline),
                  ],
                )
              : Icon(Icons.person_outline),
          icon: Icon(Icons.person_outline),
          label: 'Profil',
        ),
      ],
    );
  }
}
