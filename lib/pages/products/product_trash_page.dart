import 'package:flutter/material.dart';

class ProductTrashPage extends StatelessWidget {
  const ProductTrashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trash')),
      body: const Center(
        child: Text(
            'Deleted products will appear here. Restore or delete permanently.'),
      ),
    );
  }
}
