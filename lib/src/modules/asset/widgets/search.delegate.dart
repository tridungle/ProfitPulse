import 'package:flutter/material.dart';

class AssetSearchDelegate extends SearchDelegate {
  final List<String> favoriteAssets;
  final Map<String, Map<String, dynamic>> assetPrices;

  AssetSearchDelegate(this.favoriteAssets, this.assetPrices);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = favoriteAssets.where((asset) {
      return asset.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final asset = suggestions[index];
        final assetData = assetPrices[asset] ??
            {
              'name': 'Unknown',
              'price': 0.0,
              'changePercent': 0.0,
              'change': 0.0
            };
        final bool isPositiveChange = assetData['changePercent'] > 0;
        final double currentPrice = assetData['price'];

        return ListTile(
          title: Text(assetData['name']),
          subtitle: Text('\$${currentPrice.toStringAsFixed(4)}'),
          trailing: Icon(
            isPositiveChange ? Icons.trending_up : Icons.trending_down,
            color: isPositiveChange ? Colors.green : Colors.red,
          ),
          onTap: () {
            close(context, asset);
          },
        );
      },
    );
  }
}
