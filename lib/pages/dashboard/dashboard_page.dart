import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../providers/data_provider.dart';
import '../../utils/constants.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Hello, Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner, color: primaryOrange),
            onPressed: () {
              // TODO: Navigation to Scan Page
            },
          ),
          const CircleAvatar(
            backgroundColor: primaryOrange,
            child: Text('A', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Business Overview', style: TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 16),
            
            // Stats Row 1
            Row(
              children: [
                _buildStatCard(context, 'Total Warranties', '1,250', Icons.verified, Colors.blue),
                const SizedBox(width: 12),
                _buildStatCard(context, 'This Month', '45', Icons.calendar_month, Colors.purple),
              ],
            ),
            const SizedBox(height: 12),
            
            // Stats Row 2
            Row(
              children: [
                _buildStatCard(context, 'Customers', '850', Icons.people, Colors.orange),
                const SizedBox(width: 12),
                _buildStatCard(context, 'Total Revenue', 'PKR 450,000', Icons.account_balance_wallet, Colors.green),
              ],
            ),
            const SizedBox(height: 12),
            
            // Profit Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.withOpacity(0.5)),
              ),
              child: const Column(
                children: [
                  Text('Total Net Profit', style: TextStyle(color: Colors.green, fontSize: 14)),
                  SizedBox(height: 8),
                  Text('PKR 125,500', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            const Text('Sales Distribution', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // Pie Chart
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(value: 40, color: primaryOrange, title: 'AC/DC Fans', radius: 50, titleStyle: const TextStyle(color: Colors.white)),
                    PieChartSectionData(value: 30, color: Colors.blue, title: 'Cables', radius: 50, titleStyle: const TextStyle(color: Colors.white)),
                    PieChartSectionData(value: 30, color: Colors.grey, title: 'Other', radius: 50, titleStyle: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () {
          // TODO: Navigate to Reports
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 4),
              FittedBox(child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      ),
    );
  }
}
