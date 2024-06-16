import 'package:flutter/material.dart';
import 'package:profitpulse/src/modules/asset/models/asset.model.dart';
import 'package:profitpulse/src/modules/asset/services/asset.service.dart';
import 'package:profitpulse/src/modules/asset/services/firebase.service.dart';
import 'package:profitpulse/src/modules/portfolio/models/portfolio.model.dart';
import 'package:profitpulse/src/modules/portfolio/services/portfolio.service.dart';
import 'package:profitpulse/src/modules/portfolio/widgets/add.transaction.widget.dart';
import 'package:provider/provider.dart';
import 'package:profitpulse/src/modules/auth/providers/auth.provider.dart';

class PortfolioScreen extends StatefulWidget {
  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final PortfolioService _portfolioService = PortfolioService();
  final AssetService _assetService = AssetService();

  List<Portfolio> _transactions = [];
  List<Coin> _initialAssets = []; // Store initial assets here

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTransactions();
  }

  Future<void> _fetchTransactions() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUser = authProvider.user;
    final initialAssets = await _assetService.fetchInitialAssets();
    _initialAssets = initialAssets;
    if (!mounted) return;

    if (currentUser != null) {
      final transactions = await _firebaseService.getTransactions(context);
      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    }
  }

  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AddTransactionDialog(
          initialAssets: _initialAssets,
          onTransactionAdded: (transaction) {
            if (mounted) {
              setState(() {
                _transactions.add(transaction);
                _firebaseService.addTransaction(context, transaction);
              });
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double currentPrice = 100.0; // Replace with actual current price
    final double averageBuyPrice =
        _portfolioService.calculateAverageBuyPrice(_transactions);
    final double dca =
        _portfolioService.calculateDCA(_transactions, currentPrice);
    final double profitLoss =
        _portfolioService.calculateProfitLoss(_transactions, currentPrice);

    return Scaffold(
      appBar: AppBar(
        title: Text('Portfolio'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddTransactionDialog,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                ListTile(
                  title: Text('Average Buy Price'),
                  subtitle: Text('\$${averageBuyPrice.toStringAsFixed(2)}'),
                ),
                ListTile(
                  title: Text('DCA'),
                  subtitle: Text('\$${dca.toStringAsFixed(2)}'),
                ),
                ListTile(
                  title: Text('Profit/Loss'),
                  subtitle: Text('\$${profitLoss.toStringAsFixed(2)}'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _transactions[index];
                      return ListTile(
                        title: Text(
                            '${transaction.symbol} - ${transaction.amount} @ \$${transaction.price}'),
                        subtitle: Text(transaction.isBuy ? 'Buy' : 'Sell'),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
