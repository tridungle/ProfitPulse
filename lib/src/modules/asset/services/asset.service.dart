import 'dart:async';
import 'package:profitpulse/src/modules/asset/models/asset.model.dart';
import 'package:profitpulse/src/modules/asset/services/binance.service.dart';
import 'package:profitpulse/src/modules/asset/services/ws.service.dart';

class AssetService {
  final BinanceService _binanceService = BinanceService();
  final SocketService _assetPriceWebSocketService = SocketService();

  Future<List<Coin>> fetchInitialAssets() async {
    final assets = await _binanceService.fetchAssets();
    final prices = await _binanceService.fetchPrices();
    return _mapPriceToAssets(assets, prices);
  }

  List<Coin> _mapPriceToAssets(List<Coin> tickers, List<dynamic> prices) {
    Map<String, Map<String, dynamic>> priceMap = {};
    for (var price in prices) {
      priceMap[price.symbol] = {
        'priceChange': price.priceChange,
        'priceChangePercent': price.priceChangePercent,
        'weightedAvgPrice': price.weightedAvgPrice,
        'prevClosePrice': price.prevClosePrice,
        'lastPrice': price.lastPrice,
        'bidPrice': price.bidPrice,
        'askPrice': price.askPrice,
        'openPrice': price.openPrice,
        'highPrice': price.highPrice,
        'lowPrice': price.lowPrice,
        'volume': price.volume,
        'quoteVolume': price.quoteVolume,
      };
    }

    return tickers.map((ticker) {
      String symbol = ticker.symbol;
      if (priceMap.containsKey(symbol)) {
        final price = priceMap[symbol];
        return ticker.copyWith(
          priceChange: price!['priceChange']!.toString(),
          priceChangePercent: price['priceChangePercent'].toString(),
          weightedAvgPrice: price['weightedAvgPrice'].toString(),
          prevClosePrice: price['prevClosePrice'].toString(),
          lastPrice: price['lastPrice'].toString(),
          bidPrice: price['bidPrice'].toString(),
          askPrice: price['askPrice'].toString(),
          openPrice: price['openPrice'].toString(),
          highPrice: price['highPrice'].toString(),
          lowPrice: price['lowPrice'].toString(),
          volume: price['volume'].toString(),
          quoteVolume: price['quoteVolume'].toString(),
        );
      }
      return ticker;
    }).toList();
  }

  void updatePrices(
      Map<String, Map<String, dynamic>> assetPrices, List<dynamic> data) {
    for (var item in data) {
      final changeAsset = item['symbol'];
      if (assetPrices.containsKey(changeAsset)) {
        final baseAsset = assetPrices[changeAsset]!['name'];
        final bool isPositiveChange = _parseDouble(item['priceChange']) > 0;
        final double currentPrice = _parseDouble(item['lastPrice']);
        final double previousPrice =
            _parseDouble(assetPrices[changeAsset]?['price'].toString());
        final bool isPriceUp = (currentPrice - previousPrice) > 0;

        assetPrices[changeAsset] = {
          'price': _parseDouble(item['lastPrice']),
          'change': _parseDouble(item['priceChange']),
          'name': baseAsset,
          'icon': baseAsset.toLowerCase(),
          'changePercent': _parseDouble(item['priceChangePercent']),
          'prevPrice': previousPrice,
          'isPositiveChange': isPositiveChange,
          'isPriceUp': isPriceUp
        };
      }
    }
  }

  double _parseDouble(String? value) {
    return double.tryParse(value ?? '') ?? 0.0;
  }

  void listenPriceChange(void Function(List<dynamic>) onData) {
    _assetPriceWebSocketService.listen(onData);
  }

  void close() {
    _assetPriceWebSocketService.close();
  }
}
