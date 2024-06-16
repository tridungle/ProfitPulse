import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:async';

class SocketService {
  final String wsUrl = dotenv.env['BINANCE_SOCKET_URL']!;
  late WebSocketChannel _channel;
  late StreamSubscription _subscription;

  bool _isDisposed = false;

  SocketService() {
    _channel = WebSocketChannel.connect(
      Uri.parse('$wsUrl/!ticker@arr'),
    );
  }

  void listen(void Function(List<dynamic>) onData) {
    _subscription = _channel.stream.listen((message) {
      if (!_isDisposed) {
        List<dynamic> json = jsonDecode(message);
        List<dynamic> tickers = [];
        for (var data in json) {
          Map<String, dynamic> price = {
            'symbol': data['s'],
            'priceChangePercent': data['P'],
            'priceChange': data['p'],
            'highPrice': data['h'],
            'lowPrice': data['l'],
            'openPrice': data['o'],
            'lastPrice': data['c'],
            'weightedAvgPrice': data['w'],
          };
          tickers.add(price);
        }

        onData(tickers
            .where((item) {
              return item['symbol'].contains('USDT');
            })
            .toSet()
            .toList());
      }
    });
  }

  void close() {
    _isDisposed = true;
    _subscription.cancel();
    _channel.sink.close(status.normalClosure);
  }
}
