import 'package:flutter/material.dart';
import 'package:template/screens/pristrend.dart';
import 'package:template/screens/profil.dart';
import 'package:template/screens/ranta.dart';
import 'package:template/widgets/NavigationBar.dart';

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
      bottomNavigationBar: Navbar(currentPageIndex: 0),
    );
  }
}
