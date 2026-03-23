enum TransactionType {
  receive,
  give;

  /// Giá trị lưu vào DB
  String get value {
    switch (this) {
      case TransactionType.receive:
        return "receive";
      case TransactionType.give:
        return "give";
    }
  }

  /// Nhãn hiển thị tiếng Việt
  String get label {
    switch (this) {
      case TransactionType.receive:
        return "Nhận";
      case TransactionType.give:
        return "Cho";
    }
  }

  /// Chuyển từ chuỗi DB sang enum
  static TransactionType fromString(String value) {
    switch (value) {
      case "give":
        return TransactionType.give;
      default:
        return TransactionType.receive;
    }
  }
}
