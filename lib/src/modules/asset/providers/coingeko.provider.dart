import 'package:flutter/material.dart';
import 'package:profitpulse/src/modules/asset/services/coingecko.service.dart';

class AssertProvider with ChangeNotifier {
  final CoinGeckoService _service = CoinGeckoService();
  List<dynamic> _asserts = [];

  List<dynamic> get asserts => _asserts;

  Future<void> fetchAsserts() async {
    final data = await _service.fetchAsserts();
    _asserts = data;
    notifyListeners();
  }
}
