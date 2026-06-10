import 'package:hive/hive.dart';

part 'payment_model.g.dart';

@HiveType(typeId: 8)
class PaymentModel {
  @HiveField(0)
  final String id; // UUID

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  final String? note; // optional, e.g., "cash", "bank transfer"

  PaymentModel({
    required this.id,
    required this.amount,
    required this.date,
    this.note,
  });
}
