import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:template/models/saved_search.dart';
import 'package:template/providers/favourites_provider.dart';
import 'package:template/providers/pristrend_state.dart' show ChartProvider;
import 'package:template/screens/profil.dart';

class SaveSearchButton extends StatelessWidget {
  const SaveSearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final pristrendProvider = context.watch<ChartProvider>();
    final favouritesProvider = context.watch<FavouritesProvider>();

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.all(16),
        ),
        onPressed: user != null
            ? () {
                SavedSearch savedSearch = SavedSearch(
                  selectedRegionCode: pristrendProvider.selectedRegionCode!,
                  selectedRegionName: pristrendProvider.selectedRegionName!,
                );
                favouritesProvider.addFavourite(savedSearch);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${pristrendProvider.selectedRegionName} har sparats till favoriter.',
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            : () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ProfilScreen(),
                  ),
                ),
              },
        child: user != null
            ? const Text("Spara sökning", style: TextStyle(color: Colors.white))
            : const Text(
                "Logga in för att kunna spara sökning",
                style: TextStyle(color: Colors.white),
              ),
      ),
    );
  }
}
