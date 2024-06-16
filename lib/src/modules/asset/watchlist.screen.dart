import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:profitpulse/src/modules/asset/models/asset.model.dart';
import 'package:profitpulse/src/modules/asset/services/asset.service.dart';
import 'package:profitpulse/src/modules/asset/services/firebase.service.dart';
import 'package:profitpulse/src/modules/asset/widgets/search.delegate.dart';
import 'package:profitpulse/src/modules/asset/widgets/add.watchlist.widget.dart';
import 'package:profitpulse/src/modules/auth/providers/auth.provider.dart';

class WatchlistScreen extends StatefulWidget {
  @override
  _FavoriteAssetScreenState createState() => _FavoriteAssetScreenState();
}

class _FavoriteAssetScreenState extends State<WatchlistScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  List<String> _favoriteAssets = [];
  final Map<String, Map<String, dynamic>> _assetPrices = {};
  final AssetService _assetService = AssetService();

  bool _isLoading = true;
  List<Coin> _initialAssets = []; // Store initial assets here

  @override
  void initState() {
    super.initState();
    _fetchInitialPrices();
  }

  @override
  void dispose() {
    _assetService.close();
    super.dispose();
  }

  Future<void> _fetchInitialPrices() async {
    try {
      final initialAssets = await _assetService.fetchInitialAssets();

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.user;

      if (currentUser != null) {
        final favoriteAssets =
            await _firebaseService.getFavoriteAssets(currentUser.uid);
        if (mounted) {
          setState(() {
            _favoriteAssets = favoriteAssets;
          });
        }
      }
      if (mounted) {
        _setInitialAssets(initialAssets);

        // Start listening to the WebSocket stream after fetching initial prices
        _assetService.listenPriceChange((data) {
          if (mounted) {
            setState(() {
              _assetService.updatePrices(_assetPrices, data);
            });
          }
        });
      }
    } catch (e) {
      print('Error fetching initial prices: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _setInitialAssets(List<Coin> initialAssets) {
    setState(() {
      _initialAssets = initialAssets;
      for (var asset in initialAssets) {
        if (_favoriteAssets.contains(asset.symbol)) {
          final bool isPositiveChange = double.parse(asset.priceChange) > 0;
          _assetPrices[asset.symbol] = {
            'price': double.parse(asset.lastPrice),
            'prevPrice': double.parse(asset.lastPrice),
            'change': double.parse(asset.priceChange),
            'name': asset.baseAsset,
            'icon': asset.baseAsset.toLowerCase(),
            'changePercent': double.parse(asset.priceChangePercent),
            'isPositiveChange': isPositiveChange,
            'isPriceUp': true
          };
        }
      }
      _isLoading = false;
    });
  }

  void _onAssetAdded(String asset) {
    if (!mounted) return;
    setState(() {
      if (!_favoriteAssets.contains(asset)) {
        //final symbol = asset.toLowerCase();
        final foundAsset =
            _initialAssets.where((_asset) => _asset.symbol == asset).first;
        final baseAsset = foundAsset.baseAsset;
        print('_favoriteAssets: $baseAsset');

        final bool isPositiveChange = double.parse(foundAsset.priceChange) > 0;
        _assetPrices[asset] = {
          'price': double.parse(foundAsset.lastPrice),
          'prevPrice': double.parse(foundAsset.lastPrice),
          'change': double.parse(foundAsset.priceChange),
          'name': foundAsset.baseAsset,
          'icon': foundAsset.baseAsset.toLowerCase(),
          'changePercent': double.parse(foundAsset.priceChangePercent),
          'isPositiveChange': isPositiveChange,
          'isPriceUp': true
        };
        _favoriteAssets.add(asset);
        _firebaseService.saveFavoriteAssets(context, _favoriteAssets);
      }
      _isLoading = false;
    });
  }

  void _showAddAssetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddAssetDialog(
          initialAssets: _initialAssets,
          onAdd: _onAssetAdded,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: AssetSearchDelegate(_favoriteAssets, _assetPrices),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _showAddAssetDialog,
            ),
            Text('Watch Lists'),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(5.0),
              child: GridView.count(
                crossAxisCount: 2, // Number of items per row
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
                childAspectRatio: 2 / 1, // Adjust the aspect ratio as needed
                children: _favoriteAssets.map((asset) {
                  final assetData = _assetPrices[asset] ??
                      {
                        'name': 'Unknown',
                        'price': 0.0,
                        'changePercent': 0.0,
                        'change': 0.0,
                        'isPositiveChange': true,
                        'isPriceUp': true,
                      };
                  final bool isPositiveChange = assetData['isPositiveChange'];
                  final bool isPriceUp = assetData['isPriceUp'];

                  final icon = assetData['icon'];
                  return Card(
                    elevation: 1, // No elevation
                    margin: EdgeInsets.symmetric(vertical: 2.0),
                    shape: RoundedRectangleBorder(
                      side: BorderSide.none, // No border
                      borderRadius: BorderRadius.zero, // No rounded corners
                    ),
                    child: ListTile(
                      leading: SvgPicture.asset(
                        'assets/icons/coin/color/$icon.svg',
                        width: 30.0,
                        height: 30.0,
                        fit: BoxFit.cover,
                        placeholderBuilder: (BuildContext context) => Icon(Icons
                            .monetization_on), // Optional: Placeholder while loading
                      ),
                      title: Text(
                        assetData['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        '\$${assetData['price'].toStringAsFixed(4)}',
                        style: TextStyle(
                          color: isPriceUp ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                        softWrap:
                            true, // Allow the text to wrap if it exceeds the width
                        maxLines:
                            1, // Limit the subtitle to 1 line; adjust as needed
                        overflow: TextOverflow
                            .ellipsis, // Handle overflow with ellipsis
                      ),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isPositiveChange
                                ? Icons.trending_up
                                : Icons.trending_down,
                            color: isPositiveChange ? Colors.green : Colors.red,
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${assetData['changePercent'].toStringAsFixed(2)}%',
                            style: TextStyle(
                              color:
                                  isPositiveChange ? Colors.green : Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
