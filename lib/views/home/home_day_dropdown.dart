// ============================================================
// Chọn ngày Tết dùng WheelPicker
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/transaction_viewmodel/transaction_viewmodel.dart';
import '../shared/app_helpers.dart';
import '../shared/app_theme.dart';
import '../shared/wheel_picker.dart';

class HomeDayDropdown extends StatelessWidget {
  const HomeDayDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _DaySelector(),   // Chỉ giữ chọn ngày, chọn năm ở Cài đặt
    );
  }
}

// Nút chọn ngày → mở WheelPicker
class _DaySelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final txVM = context.watch<TransactionViewModel>();
    final day  = txVM.selectedDay;
    final items = <int?>[null, 1, 2, 3, 4, 5, 6, 7];
    final label = day == null ? 'Tất cả ngày' : AppHelpers.tetDayLabel(day);

    return _SelectorButton(
      label: label,
      onTap: () async {
        final result = await showWheelPickerSheet<int?>(
          context: context,
          items:    items,
          selected: day,
          labelOf:  (v) => v == null ? 'Tất cả ngày' : AppHelpers.tetDayLabel(v),
          title:    'Chọn ngày Tết',
        );
        if (result != null || result == null) {
          txVM.selectDay(result);
        }
      },
    );
  }
}

class _SelectorButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _SelectorButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.divider),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary)),
            ),
            const Icon(Icons.expand_more,
                size: 18, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }
}
