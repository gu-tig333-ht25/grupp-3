import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/providers/favourites_provider.dart';
import 'package:template/providers/theme_provider.dart';
import 'package:template/screens/pristrend_screen/pristrend_state.dart'
    show ChartProvider;
import 'package:template/screens/profil.dart';
import 'package:template/widgets/navigation_bar.dart';

class Favoriter extends StatelessWidget {
  const Favoriter({super.key});

  @override
  Widget build(BuildContext context) {
    final favouritesProvider = context.watch<FavouritesProvider>();
    final pristrendProvider = context.watch<ChartProvider>();
    final user = FirebaseAuth.instance.currentUser;

    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[400]!;

    return Scaffold(
      appBar: AppBar(title: Text("Favoriter"), centerTitle: true),
      body: user != null
          ? Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: FixedColumnWidth(100),
                1: FlexColumnWidth(),
                2: FixedColumnWidth(130),
              },
              children: [
                TableRow(
                  children: [
                    Text(""),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Område",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "12 mån",
                        style: Theme.of(context).textTheme.headlineSmall!,
                        //.copyWith(fontSize: 15),
                      ),
                    ),
                  ],
                ),
                ...favouritesProvider.favoriter.map((favourite) {
                  double? trend = pristrendProvider.pristrend;
                  return TableRow(
                    children: [
                      Center(
                        child: InkWell(
                          child: Stack(
                            children: [
                              Icon(
                                Icons.favorite,
                                color: const Color.fromARGB(255, 145, 26, 26),
                              ),
                              Icon(Icons.favorite_outline),
                            ],
                          ),
                          onTap: () => {
                            showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Är du säker?'),
                                  content: Text(
                                    'Vill du ta bort ${favourite.selectedRegionName} som favorit?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(
                                        context,
                                        false,
                                      ), // Cancel
                                      child: Text('Avbryt'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () => {
                                        favouritesProvider.removeFavourite(
                                          favourite,
                                        ),
                                        Navigator.pop(context, true),
                                      },
                                      child: Text(
                                        'Ta bort ${favourite.selectedRegionName}',
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          favourite.selectedRegionName,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: trend == null
                            ? Text("Laddar")
                            : Text(
                                "${trend <= 0 ? "" : " "} ${trend.toStringAsFixed(2)}%",
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      color: trend <= 0
                                          ? const Color.fromARGB(
                                              255,
                                              138,
                                              24,
                                              24,
                                            )
                                          : const Color.fromARGB(
                                              255,
                                              68,
                                              155,
                                              71,
                                            ),
                                    ),
                              ),
                      ),
                    ],
                  );
                }),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Du behöver vara inloggad för att kunna se dina favoriter",
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: borderColor, width: 1.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    backgroundColor: isDark
                        ? const Color(0xFF1E1E1E)
                        : const Color(0xFFF8F8F8),
                  ),
                  child: Text(
                    "Gå till profil för att logga in",
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProfilScreen(),
                      ),
                    ),
                  },
                ),
              ],
            ),
      bottomNavigationBar: Navbar(currentPageIndex: 1),
    );
  }
}
