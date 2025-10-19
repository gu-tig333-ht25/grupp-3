import 'package:flutter/material.dart';
import 'package:template/widgets/navigation_bar.dart';

class Favoriter extends StatelessWidget {
  const Favoriter({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cityTrender = [
      {"city": "Stockholm", "change": -2.1},
      {"city": "Göteborg", "change": -1.8},
      {"city": "Malmö", "change": -2.3},
      {"city": "Helsingborg", "change": 0.2},
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Favoriter"), centerTitle: true),
      body: Table(
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
          ...cityTrender.map((data) {
            return TableRow(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Icon(
                        Icons.favorite,
                        color: const Color.fromARGB(255, 145, 26, 26),
                      ),
                      Icon(Icons.favorite_outline),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data['city']!,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${data['change'] <= 0 ? "" : " "} ${data['change']}%",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: data['change'] <= 0
                          ? const Color.fromARGB(255, 138, 24, 24)
                          : const Color.fromARGB(255, 68, 155, 71),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
      bottomNavigationBar: Navbar(currentPageIndex: 1),
    );
  }
}
