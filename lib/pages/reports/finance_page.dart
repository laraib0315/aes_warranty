import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/database_service.dart';

class FinancePage extends StatefulWidget {
  const FinancePage({super.key});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  double _totalRevenue = 0;
  double _totalProfit = 0;
  double _totalPending = 0;
  double _todayCollection = 0;
  List<FlSpot> _revenueSpots = [];

  @override
  void initState() {
    super.initState();
    _loadFinanceData();
  }

  void _loadFinanceData() {
    final db = DatabaseService.instance;
    final warranties =
        db.warrantyBox.values.where((w) => !w.isDeleted).toList();

    _totalRevenue =
        warranties.fold(0, (sum, w) => sum + (w.sellingPrice ?? w.totalAmount));
    _totalProfit = warranties.fold(
        0,
        (sum, w) =>
            sum + ((w.sellingPrice ?? w.totalAmount) - w.product.costPrice));
    _totalPending = warranties
        .where((w) => !w.isFullyPaid)
        .fold(0, (sum, w) => sum + (w.totalAmount - w.totalPaid));

    final today = DateTime.now();
    _todayCollection = warranties
        .where((w) =>
            w.saleDate.year == today.year &&
            w.saleDate.month == today.month &&
            w.saleDate.day == today.day)
        .fold(0, (sum, w) => sum + (w.sellingPrice ?? w.totalAmount));

    // Monthly revenue spots for graph
    final monthly = <int, double>{};
    for (var w in warranties) {
      final key = w.saleDate.month;
      monthly[key] = (monthly[key] ?? 0) + (w.sellingPrice ?? w.totalAmount);
    }
    _revenueSpots =
        monthly.entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finance Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatCard('Total Revenue', _totalRevenue, Colors.green),
            _buildStatCard('Total Profit', _totalProfit, Colors.blue),
            _buildStatCard('Pending Amount', _totalPending, Colors.orange),
            _buildStatCard("Today's Collection", _todayCollection,
                const Color(0xFFE7712D)),
            const SizedBox(height: 20),
            const Text('Monthly Revenue Trend',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: const FlTitlesData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _revenueSpots,
                      isCurved: true,
                      color: const Color(0xFFE7712D),
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, double amount, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            Text(
              'PKR ${amount.toStringAsFixed(0)}',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
