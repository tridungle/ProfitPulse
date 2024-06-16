class Portfolio {
  final String id;
  final String symbol;
  final double amount;
  final double price;
  final DateTime date;
  final bool isBuy;

  Portfolio({
    required this.id,
    required this.symbol,
    required this.amount,
    required this.price,
    required this.date,
    required this.isBuy,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'symbol': symbol,
      'amount': amount,
      'price': price,
      'date': date.toIso8601String(),
      'isBuy': isBuy,
    };
  }

  static Portfolio fromMap(Map<String, dynamic> map) {
    return Portfolio(
      id: map['id'],
      symbol: map['symbol'],
      amount: map['amount'],
      price: map['price'],
      date: DateTime.parse(map['date']),
      isBuy: map['isBuy'],
    );
  }
}
