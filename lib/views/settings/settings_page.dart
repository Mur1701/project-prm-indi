// ============================================================
// Màn Cài đặt: WheelPicker chọn năm con giáp
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/enums/zodiac_enum.dart';
import '../../viewmodels/transaction_viewmodel/transaction_viewmodel.dart';
import '../../viewmodels/zodiac_viewmodel/zodiac_viewmodel.dart';
import '../shared/app_theme.dart';
import '../shared/app_widgets.dart';
import '../shared/tet_scaffold.dart';
import '../shared/wheel_picker.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final zodiacVM = context.watch<ZodiacViewModel>();
    final animal   = zodiacVM.currentAnimal;

    return TetScaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        centerTitle: false,
        title: const Text('Cài đặt',
            style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary)),
      ),
      body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
          children: [
            // Con giáp hiện tại
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Image.asset(animal.assetPath, width: 72, height: 72,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          Text(animal.emoji,
                              style: const TextStyle(fontSize: 56))),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(zodiacVM.yearLabel,
                            style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary)),
                        const SizedBox(height: 4),
                        Text('Năm ${animal.vnName}',
                            style: const TextStyle(
                                fontSize: 13, color: AppTheme.textHint)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // WheelPicker chọn năm
            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Text('🗓️', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 8),
                    Text('Chọn năm xem dữ liệu',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary)),
                  ]),
                  const SizedBox(height: 6),
                  const Text(
                    'Thay đổi năm sẽ cập nhật con giáp và dữ liệu trên toàn bộ ứng dụng.',
                    style: TextStyle(
                        fontSize: 12, color: AppTheme.textHint, height: 1.4)),
                  const SizedBox(height: 14),
                  // Nút chọn năm → mở CupertinoPicker sheet
                  _YearPickerButton(zodiacVM: zodiacVM),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Thông tin app
            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(children: [
                _Row(icon: '🧧', label: 'Ứng dụng', value: 'Lì Xì Tracker'),
                const Divider(height: 18),
                _Row(icon: '📱', label: 'Phiên bản', value: '1.0.0'),
              ]),
            ),
          ],
        ),
    );
  }
}

class _Row extends StatelessWidget {
  final String icon, label, value;
  const _Row({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Row(children: [
    Text(icon, style: const TextStyle(fontSize: 16)),
    const SizedBox(width: 10),
    Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.textHint)),
    const Spacer(),
    Text(value, style: const TextStyle(
        fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
  ]);
}

// Nút mở CupertinoPicker chọn năm
class _YearPickerButton extends StatelessWidget {
  final ZodiacViewModel zodiacVM;
  const _YearPickerButton({required this.zodiacVM});

  @override
  Widget build(BuildContext context) {
    final animal = zodiacVM.currentAnimal;
    return GestureDetector(
      onTap: () async {
        final result = await showWheelPickerSheet<int>(
          context: context,
          items:   zodiacVM.availableYears,
          selected: zodiacVM.selectedYear,
          labelOf: (y) {
            final a = ZodiacAnimal.forYear(y);
            return 'Năm ${a.animalName} ($y)';
          },
          title: 'Chọn năm',
        );
        if (result != null && context.mounted) {
          zodiacVM.selectYear(result);
          context.read<TransactionViewModel>().setYear(result);
          context.read<TransactionViewModel>().selectDay(null);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: AppTheme.bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Row(
          children: [
            Text(animal.emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Năm ${animal.vnName} (${zodiacVM.selectedYear})',
                style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            const Icon(Icons.expand_more, size: 20, color: AppTheme.textHint),
          ],
        ),
      ),
    );
  }
}
