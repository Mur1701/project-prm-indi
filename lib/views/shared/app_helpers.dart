// ============================================================
// Hàm tiện ích: format tiền VND, ngày, giờ, nhãn Tết
// ============================================================

import 'package:intl/intl.dart';

class AppHelpers {
  // "1500000" → "1.500.000 đ"
  static String formatCurrency(double amount) {
    return '${NumberFormat('#,###', 'vi_VN').format(amount)} đ';
  }

  // Có dấu +/-: receive=true → "+300.000 đ"
  static String formatSigned(double amount, bool isReceive) =>
      (isReceive ? '+' : '-') + formatCurrency(amount);

  // "2026-02-17 14:30:00" → "14:30"
  static String formatTime(String date) {
    try { return DateFormat('HH:mm').format(DateTime.parse(date)); }
    catch (_) { return ''; }
  }

  // "2026-02-17 14:30:00" → "17/02/2026"
  static String formatDate(String date) {
    try { return DateFormat('dd/MM/yyyy').format(DateTime.parse(date)); }
    catch (_) { return ''; }
  }

  // DateTime → chuỗi DB "yyyy-MM-dd HH:mm:ss"
  static String toDbDate(DateTime dt) =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(dt);

  // Mùng 1 → "Mùng 1 (17/02)"
  static String tetDayLabel(int day) {
    final date = DateTime(2026, 2, 16 + day);
    return 'Mùng $day (${DateFormat('dd/MM').format(date)})';
  }
}
