part of 'transaction_form_sheet.dart';

// ============================================================
// Các widget nhỏ dùng trong form giao dịch:
// _RelativePicker, _LockedField, _AmountField, _DateBtn, _Label
// + _ThousandSeparatorFormatter — tự chèn dấu "." mỗi 3 số
// ============================================================

// ── Formatter chèn dấu chấm ngàn ──────────────────────────────
class _ThousandSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final digits = newValue.text.replaceAll('.', '');
    if (digits.isEmpty) return newValue.copyWith(text: '');

    // Giới hạn 10 chữ số (≤ 9.999.999.999 đ)
    final capped = digits.length > 10 ? digits.substring(0, 10) : digits;

    final buffer = StringBuffer();
    for (int i = 0; i < capped.length; i++) {
      if (i > 0 && (capped.length - i) % 3 == 0) buffer.write('.');
      buffer.write(capped[i]);
    }

    final formatted = buffer.toString();
    return newValue.copyWith(
      text:      formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// ── Chọn người thân ───────────────────────────────────────────
class _RelativePicker extends StatelessWidget {
  final Relative?    selected;
  final VoidCallback onTap;
  final String?      errorText;

  const _RelativePicker({
    required this.selected,
    required this.onTap,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = selected != null;
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.bg,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              border: Border.all(
                color: hasError
                    ? AppTheme.red
                    : hasValue
                    ? AppTheme.red.withOpacity(0.4)
                    : AppTheme.divider,
                width: (hasError || hasValue) ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.person_outline,
                    size: 18,
                    color: hasError
                        ? AppTheme.red
                        : hasValue
                        ? AppTheme.red
                        : AppTheme.textHint),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    hasValue
                        ? '${selected!.name}  (${selected!.group.value})'
                        : 'Chọn người thân...',
                    style: TextStyle(
                      fontSize:   14,
                      fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
                      color: hasValue ? AppTheme.textPrimary : AppTheme.textHint,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.expand_more,
                    size: 18, color: AppTheme.textHint),
              ],
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(errorText!,
              style: const TextStyle(fontSize: 12, color: AppTheme.red)),
        ],
      ],
    );
  }
}

// ── Trường bị khóa (chế độ sửa) ───────────────────────────────
class _LockedField extends StatelessWidget {
  final String value;
  const _LockedField({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: const Color(0xFFCCCCCC)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary)),
          ),
          const Icon(Icons.lock_outline, size: 16, color: AppTheme.textHint),
        ],
      ),
    );
  }
}

// ── Ô nhập số tiền với dấu chấm ngàn ──────────────────────────
class _AmountField extends StatefulWidget {
  final TextEditingController ctrl;
  final String?               errorText;
  final ValueChanged<String>? onChanged;

  const _AmountField({
    required this.ctrl,
    this.errorText,
    this.onChanged,
  });
  @override
  State<_AmountField> createState() => _AmountFieldState();
}
class _AmountFieldState extends State<_AmountField> {
  late FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode()..addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    super.dispose();
  }

  // Khi mất focus → xóa số 0 đầu + format lại dấu chấm
  void _onFocusChange() {
    if (!_focus.hasFocus) {
      final raw = widget.ctrl.text.replaceAll('.', '');
      if (raw.isEmpty) return;

      // Bỏ số 0 ở đầu: "01111111" → "1111111"
      final normalized = raw.replaceFirst(RegExp(r'^0+'), '');
      if (normalized.isEmpty) {
        widget.ctrl.clear();
        return;
      }

      // Format lại dấu chấm ngàn
      final buffer = StringBuffer();
      for (int i = 0; i < normalized.length; i++) {
        if (i > 0 && (normalized.length - i) % 3 == 0) buffer.write('.');
        buffer.write(normalized[i]);
      }
      widget.ctrl.value = TextEditingValue(
        text:      buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.bg,
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            border: Border.all(
              color: hasError ? AppTheme.red : AppTheme.divider,
              width: hasError ? 1.5 : 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: Row(children: [
            Expanded(
              child: TextField(
                controller:   widget.ctrl,
                focusNode:    _focus,          // ← thêm focusNode
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ThousandSeparatorFormatter(),
                ],
                onChanged: widget.onChanged,
                style: const TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  border: InputBorder.none, enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none, filled: false,
                  hintText: '0', isDense: true, contentPadding: EdgeInsets.zero,
                  hintStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w300,
                      color: AppTheme.textHint),
                ),
              ),
            ),
            const Text('đ', style: TextStyle(fontSize: 16, color: AppTheme.textHint)),
          ]),
        ),
        if (hasError) ...[
          const SizedBox(height: 4),
          Text(widget.errorText!,
              style: const TextStyle(fontSize: 12, color: AppTheme.red)),
        ],
      ],
    );
  }
}

// ── Nút chọn ngày/giờ ─────────────────────────────────────────
class _DateBtn extends StatelessWidget {
  final String       text;
  final IconData     icon;
  final VoidCallback onTap;

  const _DateBtn({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.bg,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(children: [
          Icon(icon, size: 15, color: AppTheme.textHint),
          const SizedBox(width: 7),
          Flexible(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 13, color: AppTheme.textSecondary)),
          ),
        ]),
      ),
    );
  }
}

// ── Label nhỏ ─────────────────────────────────────────────────
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize:     12,
      fontWeight:   FontWeight.w600,
      color:        AppTheme.textHint,
      letterSpacing: 0.3,
    ),
  );
}