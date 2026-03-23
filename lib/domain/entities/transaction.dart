import '../enums/transaction_type_enum.dart';

class Transaction {
  final int id;
  final double amount;
  final TransactionType type;
  final int relativeId;
  final String date;
  final String note;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.relativeId,
    required this.date,
    required this.note,
  });

  /// Lấy đối tượng DateTime từ chuỗi date
  DateTime get dateTime => DateTime.tryParse(date) ?? DateTime.now();

  /// Kiểm tra có phải giao dịch nhận tiền không
  bool get isReceive => type == TransactionType.receive;
}
