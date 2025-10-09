import 'package:flutter/material.dart';
import 'package:template/screens/pristrend.dart';
import 'package:template/screens/profil.dart';
import 'package:template/screens/ranta.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Bostadskollen'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => RantaScreen(),
                    ),
                  ),
                },
                child: Text('Ränta'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PristrendScreen(),
                    ),
                  ),
                },
                child: Text('Pristrend'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ProfilScreen(),
                    ),
                  ),
                },
                child: Text('Profil'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
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
      ),
    );
  }
}
