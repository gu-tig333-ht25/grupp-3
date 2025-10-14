import 'package:flutter/material.dart';
import 'package:template/widgets/navigationbar.dart';

class Favoriter extends StatelessWidget {
  const Favoriter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favoriter")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Stack(
              children: [
                Icon(Icons.favorite, color: Colors.red, size: 500),
                Icon(Icons.favorite_outline, size: 500),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(currentPageIndex: 1),
    );
  }
}
