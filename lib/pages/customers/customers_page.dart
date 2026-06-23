import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/customer_model.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  List<CustomerModel> _customers = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  void _loadCustomers() {
    final db = DatabaseService.instance;
    _customers = db.customerBox.values.where((c) => !c.isDeleted).toList();
    setState(() {});
  }

  List<CustomerModel> get _filteredCustomers {
    if (_searchQuery.isEmpty) return _customers;
    return _customers
        .where((c) =>
            c.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            c.phone.contains(_searchQuery) ||
            c.cuid.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCustomers,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by name, phone, or CUID',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Expanded(
            child: _filteredCustomers.isEmpty
                ? const Center(child: Text('No customers found'))
                : ListView.builder(
                    itemCount: _filteredCustomers.length,
                    itemBuilder: (context, index) {
                      final customer = _filteredCustomers[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFE7712D),
                            child: Text(customer.name[0]),
                          ),
                          title: Text(customer.name),
                          subtitle:
                              Text('${customer.cuid} | ${customer.phone}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // Navigate to customer warranties
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Warranty page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add Warranty coming soon')),
          );
        },
        backgroundColor: const Color(0xFFE7712D),
        child: const Icon(Icons.add),
      ),
    );
  }
}
