import 'validation_result.dart';

class TransactionValidator {
  static const double minAmount = 1000;
  static const double maxAmount = 1000000000;
  static const int    maxNoteLen = 100;

  static ValidationResult validateAmount(double amount) {
    if (amount <= 0)        return const ValidationResult.fail('Số tiền phải lớn hơn 0');
    if (amount < minAmount) return ValidationResult.fail('Số tiền tối thiểu ${minAmount.toInt()} đ');
    if (amount > maxAmount) return const ValidationResult.fail('Số tiền không được vượt quá 1 tỷ đ');
    if (amount != amount.floorToDouble()) return const ValidationResult.fail('Số tiền phải là số nguyên');
    return const ValidationResult.ok();
  }

  static ValidationResult validateNote(String note) {
    if (note.length > maxNoteLen)
      return ValidationResult.fail('Ghi chú tối đa $maxNoteLen ký tự');
    return const ValidationResult.ok();
  }

  static ValidationResult validateDate(String date) {
    if (date.isEmpty) return const ValidationResult.fail('Ngày không hợp lệ');
    try { DateTime.parse(date); } catch (_) { return const ValidationResult.fail('Ngày không hợp lệ'); }
    return const ValidationResult.ok();
  }

  static ValidationResult validateRelativeId(int id) {
    if (id <= 0) return const ValidationResult.fail('Người thân không hợp lệ');
    return const ValidationResult.ok();
  }

  static ValidationResult validateCreate({
    required double amount, required int relativeId,
    required String date,   required String note,
  }) {
    for (final r in [validateAmount(amount), validateRelativeId(relativeId),
      validateDate(date), validateNote(note)]) {
      if (!r.isValid) return r;
    }
    return const ValidationResult.ok();
  }

  static ValidationResult validateUpdate({
    required int id, required double amount,
    required String date, required String note,
  }) {
    if (id <= 0) return const ValidationResult.fail('ID không hợp lệ');
    for (final r in [validateAmount(amount), validateDate(date), validateNote(note)]) {
      if (!r.isValid) return r;
    }
    return const ValidationResult.ok();
  }
}