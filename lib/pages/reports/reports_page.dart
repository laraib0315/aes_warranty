import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/report_provider.dart';
import '../../models/warranty_model.dart';
import 'finance_page.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Finance'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Reports', icon: Icon(Icons.bar_chart)),
            Tab(text: 'Finance', icon: Icon(Icons.attach_money)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ReportsContent(),
          const FinancePage(),
        ],
      ),
    );
  }
}

class _ReportsContent extends StatefulWidget {
  @override
  State<_ReportsContent> createState() => _ReportsContentState();
}

class _ReportsContentState extends State<_ReportsContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);
    final warranties = reportProvider.warranties;
    final bestProducts = reportProvider.bestProducts;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _statCard('Total', warranties.length.toString(), Colors.blue),
              _statCard(
                  'Active',
                  warranties
                      .where((w) => w.status == WarrantyStatus.active)
                      .length
                      .toString(),
                  Colors.green),
              _statCard(
                  'Expired',
                  warranties
                      .where((w) => w.status == WarrantyStatus.expired)
                      .length
                      .toString(),
                  Colors.red),
              _statCard(
                  'Pending',
                  warranties.where((w) => !w.isFullyPaid).length.toString(),
                  Colors.orange),
            ],
          ),
          const SizedBox(height: 16),
          // Best Selling Products
          const Text('Best Selling Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (bestProducts.isEmpty)
            const Center(child: Text('No data'))
          else
            ...bestProducts.entries.map((e) => ListTile(
                  leading: CircleAvatar(child: Text('${e.value}')),
                  title: Text(e.key),
                  trailing: Text('${e.value} units'),
                )),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: color)),
              Text(title,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
