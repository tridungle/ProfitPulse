class Coin {
  final String symbol;
  final String baseAsset;
  final String quoteAsset;
  final String priceChange;
  final String priceChangePercent;
  final String weightedAvgPrice;
  final String prevClosePrice;
  final String lastPrice;
  final String bidPrice;
  final String askPrice;
  final String openPrice;
  final String highPrice;
  final String lowPrice;
  final String volume;
  final String quoteVolume;

  Coin({
    required this.symbol,
    required this.baseAsset,
    required this.quoteAsset,
    required this.priceChange,
    required this.priceChangePercent,
    required this.weightedAvgPrice,
    required this.prevClosePrice,
    required this.lastPrice,
    required this.bidPrice,
    required this.askPrice,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.volume,
    required this.quoteVolume,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    String symbol = json['symbol'] ?? '';
    String baseAsset = symbol.replaceFirst('USDT', '');

    return Coin(
      symbol: json['symbol'],
      baseAsset: baseAsset,
      quoteAsset: 'USDT',
      priceChange: json['priceChange'] ?? '0.0',
      priceChangePercent: json['priceChangePercent'] ?? '0.0',
      weightedAvgPrice: json['weightedAvgPrice'] ?? '0.0',
      prevClosePrice: json['prevClosePrice'] ?? '0.0',
      lastPrice: json['lastPrice'] ?? '0.0',
      bidPrice: json['bidPrice'] ?? '0.0',
      askPrice: json['askPrice'] ?? '0.0',
      openPrice: json['openPrice'] ?? '0.0',
      highPrice: json['highPrice'] ?? '0.0',
      lowPrice: json['lowPrice'] ?? '0.0',
      volume: json['volume'] ?? '0.0',
      quoteVolume: json['quoteVolume'] ?? '0.0',
    );
  }

  Coin copyWith({
    String? priceChange,
    String? priceChangePercent,
    String? weightedAvgPrice,
    String? prevClosePrice,
    String? lastPrice,
    String? bidPrice,
    String? askPrice,
    String? openPrice,
    String? highPrice,
    String? lowPrice,
    String? volume,
    String? quoteVolume,
  }) {
    return Coin(
      symbol: symbol,
      baseAsset: baseAsset,
      quoteAsset: quoteAsset,
      priceChange: priceChange ?? this.priceChange,
      priceChangePercent: priceChangePercent ?? this.priceChangePercent,
      weightedAvgPrice: weightedAvgPrice ?? this.weightedAvgPrice,
      prevClosePrice: prevClosePrice ?? this.prevClosePrice,
      lastPrice: lastPrice ?? this.lastPrice,
      bidPrice: bidPrice ?? this.bidPrice,
      askPrice: askPrice ?? this.askPrice,
      openPrice: openPrice ?? this.openPrice,
      highPrice: highPrice ?? this.highPrice,
      lowPrice: lowPrice ?? this.lowPrice,
      volume: volume ?? this.volume,
      quoteVolume: quoteVolume ?? this.quoteVolume,
    );
  }
}
