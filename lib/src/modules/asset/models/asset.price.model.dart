class AssertPrice {
  final String symbol;
  final double price;

  AssertPrice({required this.symbol, required this.price});

  factory AssertPrice.fromJson(Map<String, dynamic> json) {
    return AssertPrice(
      symbol: json.keys.first,
      price: double.parse(json.values.first),
    );
  }
}
