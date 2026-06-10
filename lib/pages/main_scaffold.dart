import 'package:flutter/material.dart';
import 'dashboard/dashboard_page.dart';
import 'reports/reports_page.dart';
import 'customers/customers_page.dart';
import 'products/products_page.dart';
import 'qr_generation/qr_generation_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardPage(),
    const ReportsPage(),
    const CustomersPage(),
    const ProductsPage(),
    const QrGenerationPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFE7712D),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Customers'),
          BottomNavigationBarItem(
              icon: Icon(Icons.inventory), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR Gen'),
        ],
      ),
    );
  }
}
