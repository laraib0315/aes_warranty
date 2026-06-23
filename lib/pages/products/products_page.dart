import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/product_model.dart';
import 'add_product_page.dart';
import 'brands_page.dart';
import 'categories_page.dart';
import 'product_trash_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadProducts();
  }

  void _loadProducts() {
    final db = DatabaseService.instance;
    _products = db.productBox.values.where((p) => !p.isDeleted).toList();
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Products', icon: Icon(Icons.inventory)),
            Tab(text: 'Categories', icon: Icon(Icons.category)),
            Tab(text: 'Brands', icon: Icon(Icons.branding_watermark)),
            Tab(text: 'Trash', icon: Icon(Icons.delete_outline)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProducts,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddProductPage()),
              ).then((_) => _loadProducts());
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ProductsList(products: _products, onRefresh: _loadProducts),
          const CategoriesPage(),
          const BrandsPage(),
          const ProductTrashPage(),
        ],
      ),
    );
  }
}

class _ProductsList extends StatelessWidget {
  final List<ProductModel> products;
  final VoidCallback onRefresh;

  const _ProductsList({required this.products, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(child: Text('No products. Tap + to add.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];
        final isLowStock = p.stock <= p.lowStockLimit;
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  isLowStock ? Colors.red : const Color(0xFFE7712D),
              child: Text(p.stock.toString(),
                  style: const TextStyle(color: Colors.white)),
            ),
            title: Text(p.name),
            subtitle: Text('${p.sku} | PKR ${p.sellingPrice ?? p.costPrice}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLowStock)
                  const Icon(Icons.warning, color: Colors.red, size: 18),
                IconButton(
                  icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                  onPressed: () {
                    // Edit product
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                  onPressed: () {
                    // Move to trash
                  },
                ),
              ],
            ),
            onTap: () {
              // View product details
            },
          ),
        );
      },
    );
  }
}
