import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:profitpulse/src/modules/portfolio/models/portfolio.model.dart';
import 'package:provider/provider.dart';
import 'package:profitpulse/src/modules/auth/providers/auth.provider.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveFavoriteAssets(
      BuildContext context, List<String> favoriteAssets) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.user;

    if (currentUser == null) {
      throw Exception("User not logged in");
    }
    final userDoc = _firestore.collection('users').doc(currentUser.uid);
    await userDoc.set({'favoriteAssets': favoriteAssets});
  }

  Future<List<String>> getFavoriteAssets(String userId) async {
    final userDoc = _firestore.collection('users').doc(userId);
    final snapshot = await userDoc.get();
    if (snapshot.exists) {
      return List<String>.from(snapshot.data()?['favoriteAssets'] ?? []);
    }
    return [];
  }

  Future<void> addTransaction(
      BuildContext context, Portfolio transaction) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.user;
    if (currentUser == null) {
      throw Exception("User not logged in");
    }
    final userDoc = _firestore.collection('users').doc(currentUser.uid);
    final portfolioCollection = userDoc.collection('portfolio');
    await portfolioCollection.doc(transaction.id).set(transaction.toMap());
  }

  Future<List<Portfolio>> getTransactions(
    BuildContext context,
  ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.user;
    if (currentUser == null) {
      throw Exception("User not logged in");
    }
    final userDoc = _firestore.collection('users').doc(currentUser.uid);
    final snapshot = await userDoc.collection('portfolio').get();
    return snapshot.docs.map((doc) => Portfolio.fromMap(doc.data())).toList();
  }
}
