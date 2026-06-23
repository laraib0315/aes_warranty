import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/warranty_model.dart';
import '../../services/database_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _totalWarranties = 0;
  int _activeWarranties = 0;
  int _totalCustomers = 0;
  double _totalRevenue = 0;
  Map<int, double> _monthlyRevenue = {};
  Map<String, int> _fanDistribution = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final db = DatabaseService.instance;
    final warranties =
        db.warrantyBox.values.where((w) => !w.isDeleted).toList();
    final customers = db.customerBox.values.where((c) => !c.isDeleted).toList();

    _totalWarranties = warranties.length;
    _activeWarranties =
        warranties.where((w) => w.status == WarrantyStatus.active).length;
    _totalCustomers = customers.length;

    _totalRevenue = warranties.fold<double>(0, (sum, w) => sum + w.totalAmount);

    _monthlyRevenue = {};
    for (var w in warranties) {
      final key = w.saleDate.month;
      _monthlyRevenue[key] = (_monthlyRevenue[key] ?? 0) + w.totalAmount;
    }

    _fanDistribution = {};
    for (var w in warranties) {
      for (var item in w.items) {
        final name = item.product.category.name;
        _fanDistribution[name] = (_fanDistribution[name] ?? 0) + 1;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards
            _buildStatsRow(),
            const SizedBox(height: 24),
            // Charts Row
            _buildChartsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _statCard('Total Warranties', '$_totalWarranties', Colors.purple,
            Icons.description),
        _statCard(
            'Active', '$_activeWarranties', Colors.green, Icons.check_circle),
        _statCard('Customers', '$_totalCustomers', Colors.blue, Icons.people),
        _statCard('Revenue', 'PKR ${_totalRevenue.toStringAsFixed(0)}',
            Colors.orange, Icons.attach_money),
      ],
    );
  }

  Widget _statCard(String title, String value, Color color, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Text(value,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsRow() {
    return Column(
      children: [
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Monthly Revenue',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: _monthlyRevenue.isEmpty
                      ? const Center(child: Text('No data'))
                      : BarChart(
                          BarChartData(
                            gridData: const FlGridData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    showTitles: true, reservedSize: 40),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const months = [
                                      'Jan',
                                      'Feb',
                                      'Mar',
                                      'Apr',
                                      'May',
                                      'Jun',
                                      'Jul',
                                      'Aug',
                                      'Sep',
                                      'Oct',
                                      'Nov',
                                      'Dec'
                                    ];
                                    return Text(months[value.toInt() - 1],
                                        style: const TextStyle(fontSize: 10));
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            barGroups: _monthlyRevenue.entries.map((e) {
                              return BarChartGroupData(
                                x: e.key,
                                barRods: [
                                  BarChartRodData(
                                    toY: e.value / 1000,
                                    color: const Color(0xFFE7712D),
                                    width: 16,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Product Distribution',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 150,
                  child: _fanDistribution.isEmpty
                      ? const Center(child: Text('No data'))
                      : PieChart(
                          PieChartData(
                            sections: _fanDistribution.entries.map((e) {
                              return PieChartSectionData(
                                value: e.value.toDouble(),
                                title: '${e.value}',
                                color: Colors.primaries[_fanDistribution.keys
                                        .toList()
                                        .indexOf(e.key) %
                                    Colors.primaries.length],
                                radius: 40,
                                titleStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              );
                            }).toList(),
                            sectionsSpace: 2,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
