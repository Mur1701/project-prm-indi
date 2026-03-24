import '../../domain/validators/relative_validator.dart';
import '../../domain/validators/transaction_validator.dart';
import '../../domain/validators/user_validator.dart';

/// Trả về null = hợp lệ | String = thông báo lỗi (dùng trong TextField)
class FormValidators {
  static String? amount(String? value) {
    if (value == null || value.trim().isEmpty) return 'Vui lòng nhập số tiền';
    // Bỏ dấu chấm ngàn trước khi parse
    final raw = value.trim().replaceAll('.', '');
    final n = double.tryParse(raw);
    if (n == null) return 'Số tiền không hợp lệ';
    final r = TransactionValidator.validateAmount(n);
    return r.isValid ? null : r.error;
  }

  static String? note(String? value) {
    if (value == null) return null;
    final r = TransactionValidator.validateNote(value);
    return r.isValid ? null : r.error;
  }

  static String? relativeName(String? value) {
    if (value == null) return 'Vui lòng nhập tên';
    final r = RelativeValidator.validateName(value);
    return r.isValid ? null : r.error;
  }

  static String? userName(String? value) {
    if (value == null) return 'Vui lòng nhập tên';
    final r = UserValidator.validateName(value);
    return r.isValid ? null : r.error;
  }
}