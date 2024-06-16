import 'package:flutter/material.dart';
import 'package:profitpulse/src/modules/asset/models/asset.model.dart';
import 'package:profitpulse/src/modules/asset/widgets/search.asset.widget.dart';
import 'package:profitpulse/src/modules/portfolio/models/portfolio.model.dart';
import 'package:uuid/uuid.dart';

class AddTransactionDialog extends StatefulWidget {
  final List<Coin> initialAssets;
  final Function(Portfolio) onTransactionAdded;

  AddTransactionDialog(
      {required this.initialAssets, required this.onTransactionAdded});

  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();
  String _symbol = '';
  double _amount = 0.0;
  double _price = 0.0;
  bool _isBuy = true;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final transaction = Portfolio(
        id: Uuid().v4(),
        symbol: _symbol,
        amount: _amount,
        price: _price,
        date: DateTime.now(),
        isBuy: _isBuy,
      );
      widget.onTransactionAdded(transaction);
      Navigator.of(context).pop();
    }
  }

  void _onSelectAsset(String symbol) {
    if (!mounted) return;
    setState(() {
      _symbol = symbol;
    });
  }

  void _onSaved(String? value) {
    _amount = double.parse(value!);
  }

  void _onToggleChanged(bool value) {
    if (!mounted) return;
    setState(() {
      _isBuy = value;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Transaction'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SearchAssetWidget(
                initialAssets: widget.initialAssets,
                onSelect: _onSelectAsset,
              ),
              SizedBox(height: 16), // Adjust height based on your layout needs
              TextFormField(
                decoration: InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                onSaved: _onSaved,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an amount';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Adjust height based on your layout needs
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _price = double.parse(value!);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16), // Adjust height based on your layout needs
              SwitchListTile(
                title: Text('Buy'),
                value: _isBuy,
                onChanged: _onToggleChanged,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: Text('Add'),
        ),
      ],
    );
  }
}
