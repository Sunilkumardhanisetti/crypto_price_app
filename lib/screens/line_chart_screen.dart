import 'package:flutter/material.dart';
import 'package:crypto_price_app/widgets/price_trend_chart.dart'; // Correct import path

class LineChartScreen extends StatelessWidget {
  final String coinName;
  final List<double> historicalPrices;

  const LineChartScreen({
    super.key,
    required this.coinName,
    required this.historicalPrices,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$coinName Price Trend'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: historicalPrices.isEmpty
            ? const Center(
                child: Text('No historical data available'),
              )
            : PriceTrendChart(
                prices: historicalPrices), // Using PriceTrendChart
      ),
    );
  }
}
