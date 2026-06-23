import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/product_model.dart';

class ProductTrashPage extends StatefulWidget {
  const ProductTrashPage({super.key});

  @override
  State<ProductTrashPage> createState() => _ProductTrashPageState();
}

class _ProductTrashPageState extends State<ProductTrashPage> {
  List<ProductModel> _deletedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadTrash();
  }

  void _loadTrash() {
    final db = DatabaseService.instance;
    _deletedProducts = db.productBox.values.where((p) => p.isDeleted).toList();
    setState(() {});
  }

  Future<void> _restoreProduct(ProductModel product) async {
    final updated = product.copyWith(isDeleted: false);
    await DatabaseService.instance.productBox.put(product.id, updated);
    _loadTrash();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product restored')),
    );
  }

  Future<void> _deletePermanent(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permanent Delete'),
        content: const Text('This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await DatabaseService.instance.productBox.delete(id);
      _loadTrash();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permanently deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_deletedProducts.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No deleted products', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _deletedProducts.length,
      itemBuilder: (context, index) {
        final p = _deletedProducts[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red[100],
              child: const Icon(Icons.delete, color: Colors.red),
            ),
            title: Text(p.name),
            subtitle: Text(
                '${p.sku} | Deleted: ${p.lastUpdated.toLocal().toString().split(' ')[0]}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.restore, color: Colors.green),
                  onPressed: () => _restoreProduct(p),
                  tooltip: 'Restore',
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: () => _deletePermanent(p.id),
                  tooltip: 'Delete Permanently',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
