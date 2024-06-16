import 'package:flutter/material.dart';
import 'package:profitpulse/src/modules/asset/models/asset.model.dart';
import 'package:profitpulse/src/modules/asset/services/binance.service.dart';
import 'package:profitpulse/src/modules/asset/services/ws.service.dart';
import 'package:profitpulse/src/modules/asset/widgets/asset.item.widget.dart';

class AssertList extends StatefulWidget {
  const AssertList({super.key});

  @override
  _AssertListState createState() => _AssertListState();
}

class _AssertListState extends State<AssertList> {
  final BinanceService _service = BinanceService();
  late SocketService _socketService;

  List<Coin> _assets = [];
  List<Coin> _filteredAssets = [];

  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _socketService = SocketService();
    _fetchData();
  }

  void _updatePrice(List<dynamic> data) {
    Map<String, Map<String, dynamic>> priceMap = {};
    for (var item in data) {
      priceMap[item['symbol']] = {
        'priceChange': item['priceChange'],
        'priceChangePercent': item['priceChangePercent'],
        'lastPrice': item['lastPrice'],
        'highPrice': item['highPrice'],
        'lowPrice': item['lowPrice'],
        'openPrice': item['openPrice'],
        'weightedAvgPrice': item['weightedAvgPrice'],
      };
    }

    setState(() {
      _assets = _assets.map((asset) {
        if (priceMap.containsKey(asset.symbol)) {
          return asset.copyWith(
            priceChange:
                priceMap[asset.symbol]!['priceChange'] ?? asset.priceChange,
            priceChangePercent: priceMap[asset.symbol]!['priceChangePercent'] ??
                asset.priceChangePercent,
            lastPrice: priceMap[asset.symbol]!['lastPrice'] ?? asset.lastPrice,
            highPrice: priceMap[asset.symbol]!['highPrice'] ?? asset.highPrice,
            lowPrice: priceMap[asset.symbol]!['lowPrice'] ?? asset.lowPrice,
            openPrice: priceMap[asset.symbol]!['openPrice'] ?? asset.openPrice,
            weightedAvgPrice: priceMap[asset.symbol]!['weightedAvgPrice'] ??
                asset.weightedAvgPrice,
          );
        }
        return asset;
      }).toList();
      _filteredAssets = _assets;
    });
  }

  Future<void> _fetchData() async {
    try {
      final data = await _service.fetchAssets();
      final prices = await _service.fetchPrices();
      _assets = mapPriceToAssets(data, prices)
          .where((asset) => double.parse(asset.lastPrice) > 0)
          .toList();

      setState(() {
        _assets = _assets;
        _filteredAssets = _assets;
        _isLoading = false;
      });

      _socketService.listen((data) {
        if (mounted) {
          setState(() {
            _updatePrice(data);
          });
        }
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = error.toString();
          _isLoading = false;
        });
      }
    }
  }

  List<Coin> mapPriceToAssets(List<Coin> tickers, List<dynamic> prices) {
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

  void _filterAssets(String query) {
    setState(() {
      _filteredAssets = _assets.where((_assert) {
        final symbol = _assert.symbol.toUpperCase();
        return symbol.contains(query.toUpperCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    _socketService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterAssets,
              decoration: InputDecoration(
                labelText: 'Search Symbol',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : ListView.builder(
                        itemCount: _filteredAssets.length,
                        itemBuilder: (context, index) {
                          final _assert = _filteredAssets[index];
                          final icon = _assert.baseAsset.toLowerCase();
                          return AssertItem(
                            name: _assert.baseAsset, // Adjust as needed
                            symbol: _assert.symbol.toUpperCase(),
                            image: 'assets/icons/coin/color/$icon.svg',
                            price: double.parse(_assert.lastPrice),
                            change: double.parse(_assert.priceChange),
                            totalVolume: double.parse(_assert.volume),
                            high24h: double.parse(_assert.highPrice),
                            low24h: double.parse(_assert.lowPrice),
                            priceChangePercentage24h:
                                double.parse(_assert.priceChangePercent),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
