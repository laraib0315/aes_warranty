import 'package:flutter/material.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  final List<Map<String, dynamic>> _brands = [];

  void _addBrand() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Brand'),
        content: TextField(
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _brands.add({'name': value, 'isFilterEnabled': false});
              });
              Navigator.pop(context);
            }
          },
          decoration: const InputDecoration(hintText: 'Brand Name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brands'),
        actions: [
          IconButton(onPressed: _addBrand, icon: const Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
        itemCount: _brands.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(_brands[index]['name']),
          trailing: Switch(
            value: _brands[index]['isFilterEnabled'],
            onChanged: (val) =>
                setState(() => _brands[index]['isFilterEnabled'] = val),
          ),
        ),
      ),
    );
  }
}
