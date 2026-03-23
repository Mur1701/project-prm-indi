// ============================================================
// Chọn ngày Tết bằng WheelPicker (thay dropdown cũ)
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/transaction_viewmodel/transaction_viewmodel.dart';
import '../shared/app_helpers.dart';
import '../shared/app_theme.dart';
import '../shared/wheel_picker.dart';

class ReportDaySelector extends StatelessWidget {
  const ReportDaySelector({super.key});

  @override
  Widget build(BuildContext context) {
    final txVM  = context.watch<TransactionViewModel>();
    final day   = txVM.selectedDay;
    final label = day == null ? 'Tất cả ngày' : AppHelpers.tetDayLabel(day);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => _pick(context, txVM),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.divider),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Row(
            children: [
              Text(label,
                  style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary)),
              const Spacer(),
              const Icon(Icons.expand_more,
                  color: AppTheme.textHint, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pick(BuildContext context, TransactionViewModel txVM) async {
    final items = <int?>[null, 1, 2, 3, 4, 5, 6, 7];
    final result = await showWheelPickerSheet<int?>(
      context: context,
      items:    items,
      selected: txVM.selectedDay,
      labelOf:  (v) => v == null ? 'Tất cả ngày' : AppHelpers.tetDayLabel(v),
      title:    'Chọn ngày Tết',
    );
    if (result != null || result == null) {
      txVM.selectDay(result);
    }
  }
}
