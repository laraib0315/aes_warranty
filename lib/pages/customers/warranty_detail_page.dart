import 'package:flutter/material.dart';
import '../../models/warranty_model.dart';
import '../../utils/helpers.dart';

class WarrantyDetailPage extends StatelessWidget {
  final WarrantyModel warranty;

  const WarrantyDetailPage({super.key, required this.warranty});

  @override
  Widget build(BuildContext context) {
    final isFan = warranty.product.category.name.toLowerCase().contains('fan');

    return Scaffold(
      appBar: AppBar(title: const Text('Warranty Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('UID', warranty.uid),
            _buildInfoRow('Customer', warranty.customer.name),
            _buildInfoRow('Phone', warranty.customer.phone),
            _buildInfoRow('Product', warranty.product.name),
            _buildInfoRow('Sale Date', Helpers.formatDate(warranty.saleDate)),
            _buildInfoRow(
                'Amount',
                Helpers.formatCurrency(
                    warranty.sellingPrice ?? warranty.totalAmount)),
            if (isFan) ...[
              const Divider(),
              _buildInfoRow('Motor Warranty',
                  Helpers.formatDate(warranty.motorExpiryDate),
                  isExpired: warranty.motorExpiryDate.isBefore(DateTime.now())),
              _buildInfoRow('Board Warranty',
                  Helpers.formatDate(warranty.boardExpiryDate),
                  isExpired: warranty.boardExpiryDate.isBefore(DateTime.now())),
            ] else ...[
              const Divider(),
              _buildInfoRow('Warranty Expiry',
                  Helpers.formatDate(warranty.motorExpiryDate),
                  isExpired: warranty.motorExpiryDate.isBefore(DateTime.now())),
            ],
            const Divider(),
            _buildInfoRow(
                'Payment Status', warranty.isFullyPaid ? 'Paid' : 'Unpaid',
                statusColor: warranty.isFullyPaid ? Colors.green : Colors.red),
            if (!warranty.isFullyPaid)
              _buildInfoRow(
                  'Pending Amount',
                  Helpers.formatCurrency(
                      warranty.totalAmount - warranty.totalPaid)),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Share warranty card as PDF
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('PDF sharing coming soon')),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Save as PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {bool isExpired = false, Color? statusColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: statusColor ?? (isExpired ? Colors.red : null),
                fontWeight: isExpired ? FontWeight.bold : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
