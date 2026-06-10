import 'package:flutter/material.dart';

class WebMainScaffold extends StatelessWidget {
  const WebMainScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          // Sidebar
          WebSidebar(),
          // Main Content
          Expanded(
            flex: 4,
            child: WebDashboardContent(),
          ),
        ],
      ),
    );
  }
}

class WebSidebar extends StatelessWidget {
  const WebSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)
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
                    color: const Color(0xFFE7712D).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.verified,
                      color: Color(0xFFE7712D), size: 28),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('AES Warranty',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text('Enterprises',
                        style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          // Menu Items
          _buildMenuItem(Icons.dashboard_outlined, 'Dashboard', 0),
          _buildMenuItem(Icons.bar_chart_outlined, 'Reports', 1),
          _buildMenuItem(Icons.people_outline, 'Customers', 2),
          _buildMenuItem(Icons.inventory_2_outlined, 'Products', 3),
          _buildMenuItem(Icons.qr_code_2_outlined, 'QR Generation', 4),
          const Spacer(),
          // User Profile
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFE7712D),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Skander123',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                      Text('Admin',
                          style: TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.grey, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title:
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      onTap: () {},
    );
  }
}

class WebDashboardContent extends StatelessWidget {
  const WebDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dashboard',
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Welcome back! Here\'s what\'s happening today.',
                      style: TextStyle(color: Colors.grey)),
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
                        color: Colors.black.withOpacity(0.05), blurRadius: 5)
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 18, color: Color(0xFFE7712D)),
                    SizedBox(width: 8),
                    Text('June 2026'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Stats Cards
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            childAspectRatio: 2.2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              _buildStatCard('Total Warranties', '247', '↑ 12% from last month',
                  Colors.purple),
              _buildStatCard(
                  'Active Warranties', '198', '80% of total', Colors.green),
              _buildStatCard(
                  'Revenue (PKR)', '889,200', '↑ 8% increase', Colors.orange),
              _buildStatCard('Profit (PKR)', '197,600', '↑ 5% increase',
                  const Color(0xFFE7712D)),
            ],
          ),
          const SizedBox(height: 24),
          // Charts Row
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5)
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Revenue Trend',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        Expanded(child: Placeholder()),
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
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5)
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Recent Activities',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 16),
                        Expanded(child: Placeholder()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)
        ],
        border: Border(left: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
