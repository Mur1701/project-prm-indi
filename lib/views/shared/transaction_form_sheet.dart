// ============================================================
// Modal Thêm / Sửa giao dịch — hoàn toàn tiếng Việt
// Chế độ Thêm: chọn người thân bằng WheelPicker (bottom sheet)
// Chế độ Sửa:  trường bị khóa nền xám đậm + icon 🔒
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/relative.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/enums/transaction_type_enum.dart';
import '../../viewmodels/relative_viewmodel/relative_viewmodel.dart';
import '../../viewmodels/transaction_viewmodel/transaction_viewmodel.dart';
import 'app_helpers.dart';
import 'app_theme.dart';
import 'form_validators.dart';
import 'wheel_picker.dart';
part 'transaction_form_widgets.dart';

class TransactionFormSheet extends StatefulWidget {
  final Transaction? transaction;
  const TransactionFormSheet({super.key, this.transaction});
  @override State<TransactionFormSheet> createState() => _State();
}

class _State extends State<TransactionFormSheet> {
  final _amountCtrl = TextEditingController();
  final _noteCtrl   = TextEditingController();

  TransactionType _type          = TransactionType.receive;
  Relative?       _selectedRel;   // người thân được chọn
  DateTime        _date          = DateTime.now();
  bool            _saving        = false;

  bool get _isEdit => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final t = widget.transaction!;
      _amountCtrl.text = t.amount.toStringAsFixed(0);
      _noteCtrl.text   = t.note;
      _type            = t.type;
      _date            = t.dateTime;
      // Tìm relative từ id
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final relVM = context.read<RelativeViewModel>();
        try {
          setState(() => _selectedRel =
              relVM.relatives.firstWhere((r) => r.id == t.relativeId));
        } catch (_) {}
      });
    }
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  // ── Chọn ngày ─────────────────────────────────────────────
  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020, 1, 1),
      lastDate:  DateTime(2030, 12, 31),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
            colorScheme: const ColorScheme.light(primary: AppTheme.red)),
        child: child!,
      ),
    );
    if (d != null && mounted) {
      setState(() => _date =
          DateTime(d.year, d.month, d.day, _date.hour, _date.minute));
    }
  }

  // ── Chọn giờ ──────────────────────────────────────────────
  Future<void> _pickTime() async {
    final t = await showTimePicker(
        context: context, initialTime: TimeOfDay.fromDateTime(_date));
    if (t != null && mounted) {
      setState(() => _date =
          DateTime(_date.year, _date.month, _date.day, t.hour, t.minute));
    }
  }

  // ── Mở WheelPicker chọn người thân ───────────────────────
  Future<void> _pickRelative() async {
    final relVM   = context.read<RelativeViewModel>();
    final items   = relVM.relatives;
    if (items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chưa có người thân nào. Hãy thêm trước!')));
      return;
    }

    final result = await showWheelPickerSheet<Relative>(
      context:  context,
      items:    items,
      selected: _selectedRel,
      labelOf:  (r) => '${r.name}  (${r.group.value})',
      title:    'Chọn người thân',
    );
    if (result != null) {
      setState(() => _selectedRel = result);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ));
  }

  // ── Lưu ───────────────────────────────────────────────────
  Future<void> _save() async {
    // Lớp 1 - UI validation
    final amountErr = FormValidators.amount(_amountCtrl.text.trim());
    if (amountErr != null) {
      _showError(amountErr);
      return;
    }
    final amount = double.parse(_amountCtrl.text.trim());

    final noteErr = FormValidators.note(_noteCtrl.text);
    if (noteErr != null) {
      _showError(noteErr);
      return;
    }

    if (_selectedRel == null && !_isEdit) {
      _showError('Vui lòng chọn người thân');
      return;
    }

    setState(() => _saving = true);
    final txVM = context.read<TransactionViewModel>();
    bool ok;

    if (_isEdit) {
      ok = await txVM.updateTransaction(
        id:    widget.transaction!.id,
        amount: amount,
        date:  AppHelpers.toDbDate(_date),
        note:  _noteCtrl.text.trim(),
      );
    } else {
      ok = await txVM.addTransaction(
        amount:     amount,
        type:       _type,
        relativeId: _selectedRel!.id,
        date:       AppHelpers.toDbDate(_date),
        note:       _noteCtrl.text.trim(),
      );
    }

    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      Navigator.pop(context);
    } else {
      final err = context.read<TransactionViewModel>().lastError;
      if (err != null) _showError(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bot = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + bot),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            const SizedBox(height: 12),
            Center(child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 14),

            // Tiêu đề modal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_isEdit ? 'Sửa giao dịch' : 'Thêm giao dịch',
                    style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary)),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.bg,
                    minimumSize: const Size(32, 32),
                    padding: EdgeInsets.zero),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // ── Loại giao dịch ────────────────────────────
            _typeToggle(),
            const SizedBox(height: 18),

            // ── Số tiền ───────────────────────────────────
            const _Label('Số tiền'),
            const SizedBox(height: 8),
            _AmountField(ctrl: _amountCtrl),
            const SizedBox(height: 16),

            // ── Người thân ────────────────────────────────
            const _Label('Người thân'),
            const SizedBox(height: 8),
            _isEdit
                ? _LockedField(value: _selectedRel != null
                    ? '${_selectedRel!.name}  (${_selectedRel!.group.value})'
                    : 'Đang tải...')
                : _RelativePicker(
                    selected:  _selectedRel,
                    onTap:     _pickRelative,
                  ),
            const SizedBox(height: 16),

            // ── Ngày & Giờ ────────────────────────────────
            Row(children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Label('Ngày'),
                  const SizedBox(height: 8),
                  _DateBtn(
                    text: AppHelpers.formatDate(AppHelpers.toDbDate(_date)),
                    icon: Icons.calendar_today_outlined,
                    onTap: _pickDate,
                  ),
                ],
              )),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Label('Giờ'),
                  const SizedBox(height: 8),
                  _DateBtn(
                    text: AppHelpers.formatTime(AppHelpers.toDbDate(_date)),
                    icon: Icons.access_time_outlined,
                    onTap: _pickTime,
                  ),
                ],
              )),
            ]),
            const SizedBox(height: 16),

            // ── Ghi chú ───────────────────────────────────
            const _Label('Ghi chú (tùy chọn)'),
            const SizedBox(height: 8),
            TextField(
              controller: _noteCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Thêm ghi chú...',
                prefixIcon: Icon(Icons.note_outlined)),
            ),
            const SizedBox(height: 24),

            // ── Nút lưu ───────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : Text(
                        _isEdit ? 'Cập nhật giao dịch' : 'Lưu giao dịch',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Toggle Nhận / Cho
  Widget _typeToggle() {
    return Container(
      decoration: BoxDecoration(
          color: AppTheme.bg, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: TransactionType.values.map((t) {
          final sel = _type == t;
          return Expanded(
            child: GestureDetector(
              onTap: _isEdit ? null : () => setState(() => _type = t),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: sel ? AppTheme.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: sel
                      ? [BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 4, offset: const Offset(0, 2))]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 6),
                    Text(
                      t.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                        color: sel ? AppTheme.textPrimary : AppTheme.textHint,
                      ),
                    ),
                    if (_isEdit) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.lock_outline,
                          size: 14, color: AppTheme.textHint),
                    ],
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

