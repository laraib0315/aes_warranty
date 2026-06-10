import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFFE7712D),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Customers'),
        BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Products'),
        BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR Gen'),
      ],
    );
  }
}
