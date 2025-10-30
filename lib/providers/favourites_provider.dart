import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:template/data/pristrend_api.dart';
import 'package:template/models/saved_search.dart';

class FavouritesProvider with ChangeNotifier {
  StreamSubscription? _subscription;
  List<SavedSearch> _favoriter = [];

  List<SavedSearch> get favoriter => _favoriter;

  final PristrendApi _pristrendApi = PristrendApi();

  FavouritesProvider() {
    _pristrendApi.init();
    _init();
  }

  void _init() {
    // Listen for auth changes
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _listenToUserSavedSearchChanges(user.uid);
      } else {
        _subscription?.cancel();
        _subscription = null;
        _favoriter = [];
        notifyListeners();
      }
    });
  }

  Future<double> getTrendForRegion(String region) async {
    return await _pristrendApi.fetchTrendForRegion(selectedRegionCode: region);
  }

  void addFavourite(SavedSearch favourite) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('saved_searches')
        .doc(user.uid);

    await docRef.set({
      'savedSearches': FieldValue.arrayUnion([favourite.toJson()]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  void removeFavourite(SavedSearch favourite) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('saved_searches')
        .doc(user.uid);

    await docRef.set({
      'savedSearches': FieldValue.arrayRemove([favourite.toJson()]),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  void _listenToUserSavedSearchChanges(String uid) {
    final docRef = FirebaseFirestore.instance
        .collection('saved_searches')
        .doc(uid);

    _subscription = docRef.snapshots().listen((snapshot) async {
      if (!snapshot.exists) {
        await docRef.set({
          'savedSearches': [],
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return;
      }

      final data = snapshot.data()!;
      final List<dynamic> savedSearchesData = data['savedSearches'] ?? [];

      _favoriter = savedSearchesData
          .map(
            (favorit) =>
                SavedSearch.fromJson(Map<String, dynamic>.from(favorit)),
          )
          .toList();

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
