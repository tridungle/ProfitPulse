import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CoinGeckoService {
  final String baseUrl = dotenv.env['COINGECKO_API_URL']!;

  Future<List<dynamic>> fetchAsserts() async {
    final response = await http.get(Uri.parse('$baseUrl?vs_currency=usd'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load asserts');
    }
  }

  Future<Map<String, String>> fetchCoinImages(List<String> symbols) async {
    final response = await http.get(
        Uri.parse('$baseUrl?vs_currency=usd&symbols=${symbols.join(",")}'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      Map<String, String> coinImages = {};
      for (var coin in data) {
        coinImages[coin['symbol']] = coin['image'];
      }
      return coinImages;
    } else {
      throw Exception('Failed to load coin images');
    }
  }
}
