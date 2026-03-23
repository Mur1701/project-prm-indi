part of 'transaction_form_sheet.dart';

// ============================================================
// Các widget nhỏ dùng trong form giao dịch:
// _RelativePicker, _LockedField, _AmountField, _DateBtn, _Label
// ============================================================

class _RelativePicker extends StatelessWidget {
  final Relative? selected;
  final VoidCallback onTap;

  const _RelativePicker({required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasValue = selected != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.bg,
          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          border: Border.all(
            color: hasValue ? AppTheme.red.withOpacity(0.4) : AppTheme.divider,
            width: hasValue ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.person_outline,
              size: 18,
              color: hasValue ? AppTheme.red : AppTheme.textHint,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hasValue
                    ? '${selected!.name}  (${selected!.group.value})'
                    : 'Chọn người thân...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.normal,
                  color: hasValue ? AppTheme.textPrimary : AppTheme.textHint,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.expand_more, size: 18, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }
}

// ── Trường bị khóa (khi sửa) ──────────────────────────────────
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
                  fontSize: 14, fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary)),
          ),
          const Icon(Icons.lock_outline, size: 16, color: AppTheme.textHint),
        ],
      ),
    );
  }
}

// ── Ô nhập số tiền lớn ────────────────────────────────────────
class _AmountField extends StatelessWidget {
  final TextEditingController ctrl;
  const _AmountField({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bg,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        border: Border.all(color: AppTheme.divider),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary),
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
              hintText: '0',
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintStyle: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.w300,
                  color: AppTheme.textHint),
            ),
          ),
        ),
        const Text('đ',
            style: TextStyle(fontSize: 16, color: AppTheme.textHint)),
      ]),
    );
  }
}

// ── Nút chọn ngày/giờ ─────────────────────────────────────────
class _DateBtn extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  const _DateBtn({required this.text, required this.icon, required this.onTap});

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
      fontSize: 12, fontWeight: FontWeight.w600,
      color: AppTheme.textHint, letterSpacing: 0.3,
    ),
  );
}
