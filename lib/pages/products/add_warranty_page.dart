import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';
import '../../models/brand_model.dart';
import '../../services/database_service.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _lowStockController = TextEditingController();
  final _motorWarrantyController = TextEditingController();
  final _boardWarrantyController = TextEditingController();

  CategoryModel? _selectedCategory;
  BrandModel? _selectedBrand;
  bool _hasSellingPrice = true;
  int _motorWarrantyMonths = 12;
  int _boardWarrantyMonths = 24;

  List<CategoryModel> _categories = [];
  List<BrandModel> _brands = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final db = DatabaseService.instance;
    _categories = db.categoryBox.values.where((c) => !c.isDeleted).toList();
    _brands = db.brandBox.values.where((b) => !b.isDeleted).toList();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }
    if (_selectedBrand == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a brand')),
      );
      return;
    }

    final product = ProductModel(
      id: const Uuid().v4(),
      name: _nameController.text,
      sku: 'AES-${DateTime.now().millisecondsSinceEpoch}',
      brand: _selectedBrand!,
      category: _selectedCategory!,
      costPrice: double.parse(_costPriceController.text),
      sellingPrice:
          _hasSellingPrice ? double.parse(_sellingPriceController.text) : null,
      hasSellingPrice: _hasSellingPrice,
      stock: int.parse(_stockController.text),
      lowStockLimit: int.parse(_lowStockController.text),
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
      motorWarrantyMonths: _motorWarrantyMonths,
      boardWarrantyMonths: _boardWarrantyMonths,
    );

    await DatabaseService.instance.productBox.put(product.id, product);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added successfully')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<CategoryModel>(
                value: _selectedCategory,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
                decoration: const InputDecoration(labelText: 'Category'),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<BrandModel>(
                value: _selectedBrand,
                items: _brands
                    .map((b) => DropdownMenuItem(value: b, child: Text(b.name)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedBrand = v),
                decoration: const InputDecoration(labelText: 'Brand'),
                validator: (v) => v == null ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _costPriceController,
                decoration:
                    const InputDecoration(labelText: 'Cost Price (PKR)'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Add Selling Price'),
                  const Spacer(),
                  Switch(
                    value: _hasSellingPrice,
                    onChanged: (v) => setState(() => _hasSellingPrice = v),
                  ),
                ],
              ),
              if (_hasSellingPrice) ...[
                TextFormField(
                  controller: _sellingPriceController,
                  decoration:
                      const InputDecoration(labelText: 'Selling Price (PKR)'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: 'Stock Quantity'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _lowStockController,
                decoration:
                    const InputDecoration(labelText: 'Low Stock Alert Limit'),
                keyboardType: TextInputType.number,
                initialValue: '5',
              ),
              const SizedBox(height: 12),
              const Text('Warranty Periods (for Fans)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _motorWarrantyController,
                      decoration:
                          const InputDecoration(labelText: 'Motor (months)'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) =>
                          _motorWarrantyMonths = int.tryParse(v) ?? 12,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _boardWarrantyController,
                      decoration:
                          const InputDecoration(labelText: 'Board (months)'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) =>
                          _boardWarrantyMonths = int.tryParse(v) ?? 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE7712D),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Save Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
