import 'package:flutter/material.dart';
import '../widgets/price_trend_chart.dart';

class PriceTrendScreen extends StatelessWidget {
  final String coinName;
  final List<double> historicalPrices;

  const PriceTrendScreen({
    super.key,
    required this.coinName,
    required this.historicalPrices,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$coinName Price Trend')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: historicalPrices.isEmpty
            ? const Center(child: Text('No data available'))
            : PriceTrendChart(prices: historicalPrices),
      ),
    );
  }
}
