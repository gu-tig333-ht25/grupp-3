import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:template/screens/pristrend_screen/pristrend_main.dart';
import 'package:template/screens/pristrend_screen/pristrend_state.dart';
import 'package:template/screens/ranta.dart';
import 'package:template/state/ranta_state.dart';
import 'package:template/widgets/hem/kpi_card.dart';
import 'package:template/widgets/navigation_bar.dart';
import 'package:template/widgets/news/news_card.dart';
import 'package:template/screens/pristrend_screen/pristrend_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final rantaProvider = context.watch<RantaState>();
    final pristrendProvider = context.watch<ChartProvider>();

    FlutterNativeSplash.remove();

    return Scaffold(
      appBar: AppBar(
        title: Text('Bostadskollen'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => {
              showLicensePage(
                context: context,
                applicationIcon: Image.asset(
                  'assets/icons/app_icon.png',
                  width: 52,
                  height: 52,
                ),
                // applicationName: "Bostadskollen",
              ),
            },
            icon: Icon(Icons.info_outlined),
          ),
        ],
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
                value: rantaProvider.current,
                loading: rantaProvider.loading,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<ChartProvider>(
                builder: (context, chartProvider, child) {
                  final regionName =
                      chartProvider.selectedRegionName ?? "Region";
                  return KpiCard(
                    title: "Pristrend $regionName",
                    value: chartProvider.totalChangePercent,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PristrendScreen(),
                        ),
                      );
                    },
                  );
                },
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
