enum RelativeGroup {
  family,
  relatives,
  acquaintance;

  /// Hiển thị tên tiếng Việt trên giao diện
  String get value {
    switch (this) {
      case RelativeGroup.family:
        return "Gia đình";
      case RelativeGroup.relatives:
        return "Họ hàng";
      case RelativeGroup.acquaintance:
        return "Thân quen";
    }
  }

  /// Chuyển từ chuỗi DB sang enum
  static RelativeGroup fromString(String value) {
    switch (value) {
      case "Gia đình":
      case "family":
        return RelativeGroup.family;
      case "Họ hàng":
      case "relative":
      case "relatives":
        return RelativeGroup.relatives;
      default:
        return RelativeGroup.acquaintance;
    }
  }
}
