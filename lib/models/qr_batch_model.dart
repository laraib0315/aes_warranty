import 'package:hive/hive.dart';

part 'qr_batch_model.g.dart';

@HiveType(typeId: 11)
class QrBatchModel {
  @HiveField(0)
  final String id; // UUID

  @HiveField(1)
  final DateTime generatedDate;

  @HiveField(2)
  final int quantity; // number of QRs in batch

  @HiveField(3)
  final String purpose; // "Ceiling Fans" or "Others"

  @HiveField(4)
  final List<String> uids; // list of generated UIDs

  @HiveField(5)
  final String pdfPath; // local path to saved PDF

  QrBatchModel({
    required this.id,
    required this.generatedDate,
    required this.quantity,
    required this.purpose,
    required this.uids,
    required this.pdfPath,
  });
}
