import 'package:flutter/material.dart';
import 'package:profitpulse/src/modules/asset/models/asset.model.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchAssetWidget extends StatefulWidget {
  final List<Coin> initialAssets;
  final Function(String) onSelect;

  SearchAssetWidget({required this.initialAssets, required this.onSelect});

  @override
  _SearchAssetWidgetState createState() => _SearchAssetWidgetState();
}

class _SearchAssetWidgetState extends State<SearchAssetWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<Coin> _filteredAssets = [];

  @override
  void initState() {
    super.initState();
    _filteredAssets = widget.initialAssets;
    _searchController.addListener(_filterAssets);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterAssets);
    _searchController.dispose();
    super.dispose();
  }

  void _filterAssets() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredAssets = widget.initialAssets.where((asset) {
        return asset.symbol.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            labelText: "Search",
            prefixIcon: Icon(Icons.search),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: _filteredAssets.map((asset) {
              final icon = asset.symbol.replaceFirst('USDT', '').toLowerCase();
              return ListTile(
                leading: SvgPicture.asset(
                  'assets/icons/coin/color/$icon.svg',
                  width: 30.0,
                  height: 30.0,
                  fit: BoxFit.cover,
                  placeholderBuilder: (BuildContext context) =>
                      Icon(Icons.monetization_on),
                ),
                title: Text(asset.symbol),
                onTap: () {
                  widget.onSelect(asset.symbol);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
