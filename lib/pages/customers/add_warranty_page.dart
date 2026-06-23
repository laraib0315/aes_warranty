import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/customer_model.dart';
import '../../models/product_model.dart';
import '../../models/warranty_model.dart';
import '../../services/database_service.dart';
import '../../utils/helpers.dart';
import '../scan/scan_qr_page.dart';

class AddWarrantyPage extends StatefulWidget {
  const AddWarrantyPage({super.key});

  @override
  State<AddWarrantyPage> createState() => _AddWarrantyPageState();
}

class _AddWarrantyPageState extends State<AddWarrantyPage> {
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final List<WarrantyItemEntry> _items = [];
  double _totalAmount = 0;
  double _paidAmount = 0;
  bool _isPaid = true;
  bool _showAdvance = false;
  String _scrapMetal = 'Copper';
  double _scrapWeight = 0;
  String _scrapUnit = 'kg';
  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _addItem();
  }

  void _loadProducts() {
    final db = DatabaseService.instance;
    _products = db.productBox.values.where((p) => !p.isDeleted).toList();
  }

  void _addItem() {
    _items.add(WarrantyItemEntry(
      uid: 'AES-${const Uuid().v4().substring(0, 8).toUpperCase()}',
      product: _products.isNotEmpty ? _products.first : null,
      sellingPrice: null,
    ));
    setState(() {});
  }

  void _removeItem(int index) {
    if (_items.length > 1) {
      _items.removeAt(index);
      _calculateTotal();
      setState(() {});
    }
  }

  void _calculateTotal() {
    _totalAmount = _items.fold<double>(0, (sum, item) {
      return sum + (item.sellingPrice ?? item.product?.sellingPrice ?? 0);
    });
    _paidAmount = _isPaid ? _totalAmount : _paidAmount.clamp(0, _totalAmount);
  }

  Future<void> _scanQR(int index) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const ScanQRPage()),
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _items[index].uid = result;
      });
    }
  }

  Future<void> _saveWarranty() async {
    if (_customerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter customer name')),
      );
      return;
    }

    final validItems = _items.where((item) => item.product != null).toList();
    if (validItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one product')),
      );
      return;
    }

    final db = DatabaseService.instance;

    CustomerModel? customer;
    for (var c in db.customerBox.values) {
      if (c.phone == _customerPhoneController.text && !c.isDeleted) {
        customer = c;
        break;
      }
    }

    if (customer == null) {
      final lastSerial = db.customerBox.values.length;
      customer = CustomerModel(
        id: const Uuid().v4(),
        name: _customerNameController.text,
        phone: _customerPhoneController.text,
        cuid: Helpers.generateCUID(lastSerial),
        createdAt: DateTime.now(),
        lastUpdated: DateTime.now(),
      );
      await db.customerBox.put(customer.id, customer);
    }

    final warrantyItems = validItems.map((item) {
      return WarrantyItem(
        uid: item.uid,
        product: item.product!,
      );
    }).toList();

    final firstProduct = validItems.first.product!;
    final motorExpiry = DateTime.now()
        .add(Duration(days: firstProduct.motorWarrantyMonths * 30));
    final boardExpiry = DateTime.now()
        .add(Duration(days: firstProduct.boardWarrantyMonths * 30));

    ScrapInfo? scrapInfo;
    if (_showAdvance && _scrapWeight > 0) {
      scrapInfo = ScrapInfo(
        metalType: _scrapMetal,
        weight: _scrapWeight,
        weightUnit: _scrapUnit,
      );
    }

    final warranty = WarrantyModel(
      id: const Uuid().v4(),
      uid: validItems.first.uid,
      customer: customer,
      product: validItems.first.product!,
      saleDate: DateTime.now(),
      sellingPrice: _totalAmount,
      motorExpiryDate: motorExpiry,
      boardExpiryDate: boardExpiry,
      status: WarrantyStatus.active,
      totalAmount: _totalAmount,
      totalPaid: _isPaid ? _totalAmount : _paidAmount,
      isFullyPaid: _isPaid,
      items: warrantyItems,
      scrapInfo: scrapInfo,
    );

    await db.warrantyBox.put(warranty.id, warranty);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Warranty activated successfully!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Warranty'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveWarranty,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer details
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _customerNameController,
                      decoration: const InputDecoration(
                        labelText: 'Customer Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _customerPhoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Items list
            const Text('Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'UID',
                                border: OutlineInputBorder(),
                              ),
                              controller: TextEditingController(text: item.uid),
                              readOnly: true,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.qr_code_scanner,
                                color: Color(0xFFE7712D)),
                            onPressed: () => _scanQR(index),
                          ),
                          if (_items.length > 1)
                            IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Colors.red),
                              onPressed: () => _removeItem(index),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<ProductModel>(
                        initialValue: item.product,
                        decoration: const InputDecoration(
                          labelText: 'Product',
                          border: OutlineInputBorder(),
                        ),
                        items: _products.map((p) {
                          return DropdownMenuItem(
                            value: p,
                            child: Text(p.name),
                          );
                        }).toList(),
                        onChanged: (p) {
                          setState(() {
                            item.product = p;
                            item.sellingPrice = p?.sellingPrice;
                            _calculateTotal();
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Selling Price (PKR)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: item.sellingPrice?.toString() ?? '',
                        onChanged: (val) {
                          item.sellingPrice = double.tryParse(val) ?? 0;
                          _calculateTotal();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
            ElevatedButton.icon(
              onPressed: _addItem,
              icon: const Icon(Icons.add),
              label: const Text('Add Another Item'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE7712D),
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Payment
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Payment',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Total Amount:'),
                        const Spacer(),
                        Text('PKR ${_totalAmount.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Paid'),
                        const Spacer(),
                        Switch(
                          value: _isPaid,
                          onChanged: (v) {
                            setState(() {
                              _isPaid = v;
                              if (_isPaid) _paidAmount = _totalAmount;
                            });
                          },
                        ),
                      ],
                    ),
                    if (!_isPaid)
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Paid Amount (PKR)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          _paidAmount = double.tryParse(val) ?? 0;
                          _paidAmount = _paidAmount.clamp(0, _totalAmount);
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Advance Option
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('Advance Options',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        IconButton(
                          icon: Icon(_showAdvance
                              ? Icons.expand_less
                              : Icons.expand_more),
                          onPressed: () =>
                              setState(() => _showAdvance = !_showAdvance),
                        ),
                      ],
                    ),
                    if (_showAdvance) ...[
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _scrapMetal,
                        decoration: const InputDecoration(
                          labelText: 'Scrap Metal Type',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'Copper', child: Text('Copper')),
                          DropdownMenuItem(
                              value: 'Silver', child: Text('Silver')),
                        ],
                        onChanged: (v) => setState(() => _scrapMetal = v!),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Weight',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (val) =>
                                  _scrapWeight = double.tryParse(val) ?? 0,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: _scrapUnit,
                              decoration: const InputDecoration(
                                labelText: 'Unit',
                                border: OutlineInputBorder(),
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'kg', child: Text('Kilogram (kg)')),
                                DropdownMenuItem(
                                    value: 'g', child: Text('Gram (g)')),
                              ],
                              onChanged: (v) => setState(() => _scrapUnit = v!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WarrantyItemEntry {
  String uid;
  ProductModel? product;
  double? sellingPrice;

  WarrantyItemEntry({
    required this.uid,
    this.product,
    this.sellingPrice,
  });
}
