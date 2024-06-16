import 'package:profitpulse/src/modules/portfolio/models/portfolio.model.dart';

class PortfolioService {
  double calculateAverageBuyPrice(List<Portfolio> transactions) {
    double totalAmount = 0.0;
    double totalCost = 0.0;

    for (var transaction in transactions) {
      if (transaction.isBuy) {
        totalAmount += transaction.amount;
        totalCost += transaction.amount * transaction.price;
      }
    }

    return totalAmount > 0 ? totalCost / totalAmount : 0.0;
  }

  double calculateDCA(List<Portfolio> transactions, double currentPrice) {
    double totalAmount = 0.0;
    double totalCost = 0.0;

    for (var transaction in transactions) {
      if (transaction.isBuy) {
        totalAmount += transaction.amount;
        totalCost += transaction.amount * transaction.price;
      }
    }

    return totalAmount > 0
        ? (totalCost + totalAmount * currentPrice) / totalAmount
        : currentPrice;
  }

  double calculateProfitLoss(
      List<Portfolio> transactions, double currentPrice) {
    double totalAmount = 0.0;
    double totalCost = 0.0;

    for (var transaction in transactions) {
      if (transaction.isBuy) {
        totalAmount += transaction.amount;
        totalCost += transaction.amount * transaction.price;
      } else {
        totalAmount -= transaction.amount;
        totalCost -= transaction.amount * transaction.price;
      }
    }

    return totalAmount * currentPrice - totalCost;
  }
}
