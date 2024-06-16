import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:profitpulse/src/modules/asset/models/asset.model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BinanceService {
  final String apiUrl = dotenv.env['BINANCE_API_URL']!;

  Future<List<Coin>> fetchAssets() async {
    final response =
        await http.get(Uri.parse('$apiUrl/exchangeInfo?permissions=SPOT'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> symbols = data['symbols'];
      List<dynamic> coins = symbols
          .where((item) {
            return item['symbol'].contains('USDT');
          })
          .toSet()
          .toList();
      return coins.map((coin) => Coin.fromJson(coin)).toList();
    } else {
      throw Exception('Failed to load coins. Status: ${response.statusCode}');
    }
  }

  Future<List<dynamic>> fetchPrices() async {
    final response = await http.get(Uri.parse('$apiUrl/ticker/24hr'));

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        return data.map((coin) => Coin.fromJson(coin)).toList();
      } catch (error) {
        print('fetchPrices error: $error');
        return [];
      }
    } else {
      print(response.statusCode);
      throw Exception('Failed to load coins');
    }
  }
}
