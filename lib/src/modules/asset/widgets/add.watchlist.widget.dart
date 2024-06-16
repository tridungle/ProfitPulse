import 'package:flutter/material.dart';
import 'package:profitpulse/src/modules/asset/models/asset.model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:profitpulse/src/modules/asset/widgets/search.asset.widget.dart';

class AddAssetDialog extends StatefulWidget {
  final List<Coin> initialAssets;
  final Function(String) onAdd;

  AddAssetDialog({required this.initialAssets, required this.onAdd});

  @override
  _AddAssetDialogState createState() => _AddAssetDialogState();
}

class _AddAssetDialogState extends State<AddAssetDialog> {
  List<Coin> _filteredAssets = [];

  @override
  void initState() {
    super.initState();
    _filteredAssets = widget.initialAssets;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(""),
      content: SizedBox(
        width: 320.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: SearchAssetWidget(
              initialAssets: widget.initialAssets,
              onSelect: (symbol) {
                widget.onAdd(symbol);
                Navigator.of(context).pop();
              },
            )),
            SizedBox(height: 10),
            // Wrap ListView with Expanded to constrain its height
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: _filteredAssets.map((asset) {
                  final icon =
                      asset.symbol.replaceFirst('USDT', '').toLowerCase();
                  return ListTile(
                    leading: SvgPicture.asset(
                      'assets/icons/coin/color/$icon.svg',
                      width: 30.0,
                      height: 30.0,
                      fit: BoxFit.cover,
                      placeholderBuilder: (BuildContext context) => Icon(Icons
                          .monetization_on), // Optional: Placeholder while loading
                    ),
                    title: Text(asset.symbol),
                    onTap: () {
                      widget.onAdd(asset.symbol);
                      Navigator.of(context).pop();
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
