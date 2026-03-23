part of 'report_page.dart';

// ============================================================
// Nút lọc nhóm người thân → mở WheelPicker
// ============================================================

class _GroupFilterButton extends StatelessWidget {
  final RelativeGroup? selected;
  final ValueChanged<RelativeGroup?> onChanged;
  const _GroupFilterButton({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = <RelativeGroup?>[null, ...RelativeGroup.values];
    return GestureDetector(
      onTap: () async {
        final result = await showWheelPickerSheet<RelativeGroup?>(
          context: context,
          items:    items,
          selected: selected,
          labelOf:  (g) => g == null ? 'Tất cả nhóm' : g.value,
          title:    'Lọc theo nhóm',
        );
        if (result != null || result == null) {
          onChanged(result);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected != null ? AppTheme.redLight : AppTheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected != null ? AppTheme.red : AppTheme.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selected?.value ?? 'Tất cả',
              style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600,
                color: selected != null
                    ? AppTheme.red : AppTheme.textSecondary),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.tune, size: 14, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }
}
