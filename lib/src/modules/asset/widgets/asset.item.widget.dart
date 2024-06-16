import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssertItem extends StatelessWidget {
  final String name;
  final String symbol;
  final double price;
  final double change;
  final String image;
  final double totalVolume;
  final double high24h;
  final double low24h;
  final double priceChangePercentage24h;

  const AssertItem({
    Key? key,
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.image,
    required this.totalVolume,
    required this.high24h,
    required this.low24h,
    required this.priceChangePercentage24h,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  image,
                  width: 60.0,
                  height: 60.0,
                  fit: BoxFit.cover,
                  placeholderBuilder: (BuildContext context) => Icon(Icons
                      .monetization_on), // Optional: Placeholder while loading
                ),
                SizedBox(width: 5.0),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          symbol,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${change.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: change > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildInfoColumn(
                      label: 'Volume', value: formatVolume(totalVolume)),
                  SizedBox(width: 10.0),
                  _buildInfoColumn(
                      label: 'High 24h',
                      value: '\$${high24h.toStringAsFixed(2)}'),
                  SizedBox(width: 10.0),
                  _buildInfoColumn(
                      label: 'Low 24h',
                      value: '\$${low24h.toStringAsFixed(2)}'),
                  SizedBox(width: 10.0),
                  _buildInfoColumn(
                      label: 'Change 24h',
                      value: '${priceChangePercentage24h.toStringAsFixed(2)}%',
                      textAlign: TextAlign.right,
                      crossAxisAlignment: CrossAxisAlignment.end),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatVolume(double volume) {
    if (volume >= 1000000000) {
      return '${(volume / 1000000000).toStringAsFixed(2)} B';
    } else if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(2)} M';
    } else {
      return volume.toStringAsFixed(2);
    }
  }

  Widget _buildInfoColumn(
      {required String label,
      required String value,
      TextStyle? labelStyle,
      TextStyle? valueStyle,
      TextAlign textAlign = TextAlign.start,
      crossAxisAlignment =
          CrossAxisAlignment.start // Default alignment is start (left)
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            label,
            style: labelStyle ??
                TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey[600],
                ),
            textAlign: textAlign,
          ),
          SizedBox(height: 10.0),
          Text(
            value,
            style: valueStyle ??
                TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: textAlign,
          ),
        ],
      ),
    );
  }
}
