import 'validation_result.dart';

class RelativeValidator {
  static const int maxNameLen = 30;
  static final RegExp _forbidden = RegExp(r'[<>{}()\[\]\\\/\|;`"' + "'" + r'$%^*=+]');

  static ValidationResult validateName(String name) {
    final t = name.trim();
    if (t.isEmpty)        return const ValidationResult.fail('Tên không được để trống');
    if (t.length > maxNameLen) return ValidationResult.fail('Tên tối đa $maxNameLen ký tự');
    if (_forbidden.hasMatch(t)) return const ValidationResult.fail('Tên chứa ký tự không hợp lệ');
    return const ValidationResult.ok();
  }

  static ValidationResult validateGroup(String group) {
    const allowed = ['family', 'relatives', 'acquaintance'];
    if (!allowed.contains(group)) return const ValidationResult.fail('Nhóm không hợp lệ');
    return const ValidationResult.ok();
  }
}