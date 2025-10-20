import 'package:flutter/material.dart';
import 'package:template/apis/news_api.dart';
import 'package:template/screens/pristrend.dart';
import 'package:template/screens/ranta.dart';
import 'package:template/widgets/hem/kpi_card.dart';
import 'package:template/widgets/navigation_bar.dart';
import 'package:template/widgets/news/news_card.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(16.0)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: KpiCard(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => RantaScreen(),
                    ),
                  ),
                },
                title: "Styrränta",
                value: 1.75,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: KpiCard(
                title: "Pristrend 12 månader",
                value: -2.1,
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PristrendScreen(),
                    ),
                  ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF597FD0),
                  foregroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Bolånekalkyl",
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall!.copyWith(color: Colors.white),
                  ),
                ),

                // textColor: Colors.white,
                // color: Colors.blue,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Nyheter",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),

            NewsCard(),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(currentPageIndex: 0),
    );
  }
}
