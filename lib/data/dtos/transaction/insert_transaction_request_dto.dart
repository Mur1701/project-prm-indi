import '../../../domain/enums/transaction_type_enum.dart';

class InsertTransactionRequestDTO {
  final double amount;
  final TransactionType type;
  final int relativeId;
  final String date;
  final String note;

  InsertTransactionRequestDTO({
    required this.amount,
    required this.type,
    required this.relativeId,
    required this.date,
    required this.note,
  });
}
