import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PriceTrendChart extends StatelessWidget {
  final List<double> prices;

  const PriceTrendChart({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false), // Hide grid lines
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true, // Display y-axis titles
              reservedSize: 40, // Space for the titles
              getTitlesWidget: (value, meta) => Text(
                value.toStringAsFixed(2), // Format values
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true, // Display x-axis titles
              reservedSize: 20, // Adjust space if needed
              getTitlesWidget: (value, meta) => Text(
                value.toStringAsFixed(0), // Format values
                style: const TextStyle(fontSize: 10),
              ),
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(color: Colors.black, width: 1),
            bottom: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        minX: 0,
        maxX: (prices.length - 1).toDouble(),
        minY: prices.isEmpty ? 0 : prices.reduce((a, b) => a < b ? a : b),
        maxY: prices.isEmpty ? 1 : prices.reduce((a, b) => a > b ? a : b),
        lineBarsData: [
          LineChartBarData(
            spots: prices
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                .toList(),
            isCurved: true, // Smooth curve
            color: Colors.blue, // Line color
            barWidth: 3, // Line thickness
            belowBarData: BarAreaData(show: false), // No shaded area
          ),
        ],
      ),
    );
  }
}
