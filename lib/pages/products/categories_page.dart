import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final List<String> _categories = [];

  void _addCategory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              setState(() => _categories.add(value));
              Navigator.pop(context);
            }
          },
          decoration: const InputDecoration(hintText: 'Category Name'),
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
        title: const Text('Categories'),
        actions: [
          IconButton(onPressed: _addCategory, icon: const Icon(Icons.add))
        ],
      ),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(_categories[index]),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => setState(() => _categories.removeAt(index)),
          ),
        ),
      ),
    );
  }
}
