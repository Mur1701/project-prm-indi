class TransactionDTO {
  final int id;
  final double amount;
  final String type;
  final int relativeId;
  final String date;
  final String note;

  TransactionDTO({
    required this.id,
    required this.amount,
    required this.type,
    required this.relativeId,
    required this.date,
    required this.note,
  });

  /// Chuyển object thành Map để insert/update DB
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "amount": amount,
      "type": type,
      "relative_id": relativeId,
      "date": date,
      "note": note,
    };
  }

  /// Tạo DTO từ Map trả về từ DB
  factory TransactionDTO.fromMap(Map<String, dynamic> map) {
    return TransactionDTO(
      id: map["id"],
      amount: (map["amount"] as num).toDouble(),
      type: map["type"],
      relativeId: map["relative_id"],
      date: map["date"],
      note: map["note"] ?? '',
    );
  }
}
