import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/database_service.dart';
import '../../models/warranty_model.dart';
import 'package:fl_chart/fl_chart.dart';

class WebMainScaffold extends StatefulWidget {
  const WebMainScaffold({super.key});

  @override
  State<WebMainScaffold> createState() => _WebMainScaffoldState();
}

class _WebMainScaffoldState extends State<WebMainScaffold> {
  int _selectedIndex = 0;
  late Map<String, dynamic> _dashboardData;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _loadDashboardData() {
    final db = DatabaseService.instance;
    final warranties =
        db.warrantyBox.values.where((w) => !w.isDeleted).toList();
    final customers = db.customerBox.values.where((c) => !c.isDeleted).toList();

    _dashboardData = {
      'totalWarranties': warranties.length,
      'activeWarranties':
          warranties.where((w) => w.status == WarrantyStatus.active).length,
      'totalCustomers': customers.length,
      'totalRevenue':
          warranties.fold<double>(0, (sum, w) => sum + w.totalAmount),
      'monthlyRevenue': _getMonthlyRevenue(warranties),
      'fanDistribution': _getFanDistribution(warranties),
    };
  }

  Map<int, double> _getMonthlyRevenue(List<WarrantyModel> warranties) {
    final monthly = <int, double>{};
    for (var w in warranties) {
      final key = w.saleDate.month;
      monthly[key] = (monthly[key] ?? 0) + w.totalAmount;
    }
    return monthly;
  }

  Map<String, int> _getFanDistribution(List<WarrantyModel> warranties) {
    final distribution = <String, int>{};
    for (var w in warranties) {
      for (var item in w.items) {
        final name = item.product.category.name;
        distribution[name] = (distribution[name] ?? 0) + 1;
      }
    }
    return distribution;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 260,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 32),
                // Logo
                Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7712D).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Color(0xFFE7712D),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AES Warranty',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Enterprises',
                            style: TextStyle(color: Colors.grey, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Menu Items
                _buildMenuItem(
                    Icons.dashboard_outlined, 'Dashboard', 0, context),
                _buildMenuItem(Icons.bar_chart_outlined, 'Reports', 1, context),
                _buildMenuItem(Icons.people_outline, 'Customers', 2, context),
                _buildMenuItem(
                    Icons.inventory_2_outlined, 'Products', 3, context),
                _buildMenuItem(
                    Icons.qr_code_2_outlined, 'QR Generation', 4, context),
                const Spacer(),
                // User Profile
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xFFE7712D),
                        child: Text(
                          // ✅ FIXED: Proper null check
                          user != null && user.username.isNotEmpty
                              ? user.username[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.username ?? 'Skander123',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              user?.role.name ?? 'Admin',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout,
                            color: Colors.grey, size: 20),
                        onPressed: () async {
                          await authProvider.logout();
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, '/');
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          // Main Content
          Expanded(
            flex: 4,
            child: _selectedIndex == 0
                ? WebDashboardContent(data: _dashboardData)
                : _getPageContent(_selectedIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      IconData icon, String label, int index, BuildContext context) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? const Color(0xFFE7712D) : Colors.grey,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFFE7712D) : Colors.grey,
          fontSize: 14,
        ),
      ),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      selected: isSelected,
    );
  }

  Widget _getPageContent(int index) {
    switch (index) {
      case 1:
        return const Center(
            child: Text('Reports Page', style: TextStyle(fontSize: 24)));
      case 2:
        return const Center(
            child: Text('Customers Page', style: TextStyle(fontSize: 24)));
      case 3:
        return const Center(
            child: Text('Products Page', style: TextStyle(fontSize: 24)));
      case 4:
        return const Center(
            child: Text('QR Generation Page', style: TextStyle(fontSize: 24)));
      default:
        return const Center(
            child: Text('Page Coming Soon', style: TextStyle(fontSize: 24)));
    }
  }
}

// ==================== WebDashboardContent ====================

class WebDashboardContent extends StatelessWidget {
  final Map<String, dynamic> data;

  const WebDashboardContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final totalWarranties = data['totalWarranties'] ?? 0;
    final activeWarranties = data['activeWarranties'] ?? 0;
    final totalCustomers = data['totalCustomers'] ?? 0;
    final totalRevenue = data['totalRevenue'] ?? 0.0;
    final monthlyRevenue = data['monthlyRevenue'] as Map<int, double>? ?? {};
    final fanDistribution = data['fanDistribution'] as Map<String, int>? ?? {};

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Welcome back! Here\'s what\'s happening today.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Color(0xFFE7712D),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${DateTime.now().month} ${DateTime.now().year}',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            childAspectRatio: 2.2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              _buildStatCard(
                'Total Warranties',
                totalWarranties.toString(),
                '↑ Active: $activeWarranties',
                Colors.purple,
              ),
              _buildStatCard(
                'Active Warranties',
                activeWarranties.toString(),
                '${totalWarranties > 0 ? ((activeWarranties / totalWarranties) * 100).toStringAsFixed(0) : 0}% of total',
                Colors.green,
              ),
              _buildStatCard(
                'Revenue (PKR)',
                '${(totalRevenue / 1000).toStringAsFixed(1)}k',
                '↑ ${totalRevenue > 0 ? ((totalRevenue / 1000).toStringAsFixed(1)) : 0}k total',
                Colors.orange,
              ),
              _buildStatCard(
                'Customers',
                totalCustomers.toString(),
                'Total registered',
                const Color(0xFFE7712D),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Charts Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monthly Revenue Trend',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: monthlyRevenue.isEmpty
                            ? const Center(child: Text('No data yet'))
                            : BarChart(
                                BarChartData(
                                  gridData: const FlGridData(show: false),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            '${(value / 1000).toStringAsFixed(0)}k',
                                            style:
                                                const TextStyle(fontSize: 10),
                                          );
                                        },
                                      ),
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
                                          return Text(
                                            months[value.toInt() - 1],
                                            style:
                                                const TextStyle(fontSize: 10),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: monthlyRevenue.entries.map((e) {
                                    return BarChartGroupData(
                                      x: e.key,
                                      barRods: [
                                        BarChartRodData(
                                          toY: e.value,
                                          color: const Color(0xFFE7712D),
                                          width: 20,
                                          borderRadius:
                                              BorderRadius.circular(4),
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
              const SizedBox(width: 20),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Distribution',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: fanDistribution.isEmpty
                            ? const Center(child: Text('No data yet'))
                            : PieChart(
                                PieChartData(
                                  sections: fanDistribution.entries.map((e) {
                                    final colors = [
                                      const Color(0xFFE7712D),
                                      Colors.blue,
                                      Colors.green,
                                      Colors.purple,
                                      Colors.teal,
                                    ];
                                    return PieChartSectionData(
                                      value: e.value.toDouble(),
                                      title: e.key,
                                      color: colors[fanDistribution.keys
                                              .toList()
                                              .indexOf(e.key) %
                                          colors.length],
                                      radius: 80,
                                      titleStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
          ),
        ],
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
