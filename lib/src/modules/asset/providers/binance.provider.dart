import 'package:flutter/material.dart';
import 'package:profitpulse/src/modules/asset/models/asset.model.dart';
import 'package:profitpulse/src/modules/asset/services/binance.service.dart';

class BinanceAssertProvider with ChangeNotifier {
  final BinanceService _service = BinanceService();
  List<Coin> _assets = [];

  List<Coin> get assets => _assets;

  Future<void> fetchAssets() async {
    final data = await _service.fetchAssets();
    _assets = data;
    notifyListeners();
  }
}
