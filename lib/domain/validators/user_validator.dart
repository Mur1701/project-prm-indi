import 'validation_result.dart';

class UserValidator {
  static const int maxLen = 20;

  static ValidationResult validateName(String name) {
    final t = name.trim();
    if (t.isEmpty)      return const ValidationResult.fail('Tên không được để trống');
    if (t.length > maxLen) return ValidationResult.fail('Tên tối đa $maxLen ký tự');
    return const ValidationResult.ok();
  }
}