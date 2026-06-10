import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/product_model.dart';
import '../../models/warranty_model.dart';
import '../../models/customer_model.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  int _tabIndex = 0;
  late List<ProductModel> _deletedProducts;
  late List<WarrantyModel> _deletedWarranties;
  late List<CustomerModel> _deletedCustomers;

  @override
  void initState() {
    super.initState();
    _loadTrash();
  }

  void _loadTrash() {
    final db = DatabaseService.instance;
    _deletedProducts = db.productBox.values.where((p) => p.isDeleted).toList();
    _deletedWarranties =
        db.warrantyBox.values.where((w) => w.isDeleted).toList();
    _deletedCustomers =
        db.customerBox.values.where((c) => c.isDeleted).toList();
  }

  Future<void> _restoreProduct(ProductModel product) async {
    final updated = product.copyWith(isDeleted: false);
    await DatabaseService.instance.productBox.put(product.id, updated);
    if (!mounted) return; // ✅ Added
    setState(() => _loadTrash());
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Restored')));
  }

  Future<void> _deletePermanently(String id, String boxName) async {
    final db = DatabaseService.instance;
    if (boxName == 'products') {
      await db.productBox.delete(id);
    } else if (boxName == 'warranties') {
      await db.warrantyBox.delete(id);
    } else if (boxName == 'customers') {
      await db.customerBox.delete(id);
    }
    if (!mounted) return; // ✅ Added
    setState(() => _loadTrash());
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Permanently deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trash')),
      body: Column(
        children: [
          TabBar(
            tabs: const [
              Tab(text: 'Products'),
              Tab(text: 'Warranties'),
              Tab(text: 'Customers'),
            ],
            onTap: (i) => setState(() => _tabIndex = i),
          ),
          Expanded(
            child: IndexedStack(
              index: _tabIndex,
              children: [
                _buildList(
                    _deletedProducts,
                    'products',
                    (item) => _restoreProduct(item as ProductModel),
                    (id) => _deletePermanently(id, 'products')),
                _buildList(_deletedWarranties, 'warranties', null,
                    (id) => _deletePermanently(id, 'warranties')),
                _buildList(_deletedCustomers, 'customers', null,
                    (id) => _deletePermanently(id, 'customers')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List items, String type, Function(dynamic)? onRestore,
      Function(String) onDelete) {
    if (items.isEmpty) {
      return const Center(child: Text('No deleted items'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        String title = '';
        if (type == 'products') {
          title = (item as ProductModel).name;
        } else if (type == 'warranties') {
          title = (item as WarrantyModel).uid;
        } else if (type == 'customers') {
          title = (item as CustomerModel).name;
        }

        return ListTile(
          title: Text(title),
          subtitle: Text(type),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onRestore != null)
                IconButton(
                  icon: const Icon(Icons.restore, color: Colors.green),
                  onPressed: () => onRestore(item),
                ),
              IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                onPressed: () => onDelete(item.id),
              ),
            ],
          ),
        );
      },
    );
  }
}
