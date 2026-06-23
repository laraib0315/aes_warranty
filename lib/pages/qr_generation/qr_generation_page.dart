import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../services/database_service.dart';
import '../../models/qr_batch_model.dart';
import 'qr_settings_page.dart';
import 'qr_pdf_preview.dart';

class QrGenerationPage extends StatefulWidget {
  const QrGenerationPage({super.key});

  @override
  State<QrGenerationPage> createState() => _QrGenerationPageState();
}

class _QrGenerationPageState extends State<QrGenerationPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _quantity = 35;
  String _purpose = 'Ceiling Fans';
  List<QrBatchModel> _batches = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadBatches();
  }

  void _loadBatches() {
    final db = DatabaseService.instance;
    _batches = db.qrBatchBox.values.toList()
      ..sort((a, b) => b.generatedDate.compareTo(a.generatedDate));
    setState(() {});
  }

  Future<void> _generateBatch() async {
    final uids = <String>[];
    for (int i = 0; i < _quantity; i++) {
      uids.add('AES-${const Uuid().v4().substring(0, 8).toUpperCase()}');
    }

    final batch = QrBatchModel(
      id: const Uuid().v4(),
      generatedDate: DateTime.now(),
      quantity: _quantity,
      purpose: _purpose,
      uids: uids,
      pdfPath: '',
    );

    await DatabaseService.instance.qrBatchBox.put(batch.id, batch);
    _loadBatches();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QrPdfPreviewPage(uids: uids, purpose: _purpose),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Generation'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Generate', icon: Icon(Icons.qr_code)),
            Tab(text: 'History', icon: Icon(Icons.history)),
            Tab(text: 'Settings', icon: Icon(Icons.settings)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _GenerateTab(
            quantity: _quantity,
            purpose: _purpose,
            onQuantityChanged: (v) => setState(() => _quantity = v),
            onPurposeChanged: (v) => setState(() => _purpose = v),
            onGenerate: _generateBatch,
          ),
          _HistoryTab(batches: _batches),
          const QrSettingsPage(),
        ],
      ),
    );
  }
}

class _GenerateTab extends StatelessWidget {
  final int quantity;
  final String purpose;
  final Function(int) onQuantityChanged;
  final Function(String) onPurposeChanged;
  final VoidCallback onGenerate;

  const _GenerateTab({
    required this.quantity,
    required this.purpose,
    required this.onQuantityChanged,
    required this.onPurposeChanged,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('Generate QR Batch',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text('Quantity:'),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () =>
                            onQuantityChanged(quantity > 1 ? quantity - 1 : 1),
                      ),
                      Text('$quantity',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => onQuantityChanged(quantity + 1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: purpose,
                    decoration: const InputDecoration(labelText: 'Purpose'),
                    items: const [
                      DropdownMenuItem(
                          value: 'Ceiling Fans',
                          child: Text('Ceiling Fans (QR + Barcode)')),
                      DropdownMenuItem(
                          value: 'Others', child: Text('Others (Only QR)')),
                    ],
                    onChanged: (v) => onPurposeChanged(v!),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onGenerate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE7712D),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Generate PDF',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  final List<QrBatchModel> batches;

  const _HistoryTab({required this.batches});

  @override
  Widget build(BuildContext context) {
    if (batches.isEmpty) {
      return const Center(child: Text('No batches generated yet'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: batches.length,
      itemBuilder: (context, index) {
        final b = batches[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.qr_code),
            title: Text('${b.quantity} QRs'),
            subtitle: Text(
                '${b.purpose} | ${b.generatedDate.toLocal().toString().split(' ')[0]}'),
            trailing: Text('${b.uids.length} UIDs'),
            onTap: () {
              // Show batch details
            },
          ),
        );
      },
    );
  }
}
