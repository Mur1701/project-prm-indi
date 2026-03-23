class ValidationResult {
  final bool isValid;
  final String? error;

  const ValidationResult._({required this.isValid, this.error});
  const ValidationResult.ok() : this._(isValid: true);
  const ValidationResult.fail(String message)
      : this._(isValid: false, error: message);
}