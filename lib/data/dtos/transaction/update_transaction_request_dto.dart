class UpdateTransactionRequestDTO {
  final int id;
  final double amount;
  final String date;
  final String note;

  UpdateTransactionRequestDTO({
    required this.id,
    required this.amount,
    required this.date,
    required this.note,
  });
}