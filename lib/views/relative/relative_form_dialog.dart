// ============================================================
// FILE: views/relative/relative_form_dialog.dart
// Dialog thêm người thân — lỗi hiển thị inline đỏ dưới field
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/enums/relative_group_enum.dart';
import '../../viewmodels/relative_viewmodel/relative_viewmodel.dart';
import '../shared/app_theme.dart';
import '../shared/form_validators.dart';

class RelativeFormDialog extends StatefulWidget {
  const RelativeFormDialog({super.key});

  @override
  State<RelativeFormDialog> createState() => _State();
}

class _State extends State<RelativeFormDialog> {
  final _nameCtrl = TextEditingController();
  RelativeGroup _group  = RelativeGroup.family;
  bool          _saving = false;
  String?       _nameError;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    // Validate — gán lỗi vào state, hiện đỏ dưới field
    final err = FormValidators.relativeName(_nameCtrl.text);
    setState(() => _nameError = err);
    if (err != null) return;

    setState(() => _saving = true);
    final ok = await context
        .read<RelativeViewModel>()
        .addRelative(_nameCtrl.text.trim(), _group);
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Thêm người thân',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
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
            const SizedBox(height: 20),

            // ── Tên ─────────────────────────────────────
            const Text('Tên',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textHint)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameCtrl,
              autofocus: true,
              maxLength: 30,
              buildCounter: (_, {required currentLength,
                required isFocused, maxLength}) => null,
              textCapitalization: TextCapitalization.words,
              onChanged: (_) {
                // Xóa lỗi ngay khi người dùng bắt đầu gõ lại
                if (_nameError != null) setState(() => _nameError = null);
              },
              decoration: InputDecoration(
                hintText: 'Nhập tên người thân',
                errorText: _nameError,
                errorStyle: const TextStyle(
                    fontSize: 12, color: AppTheme.red),
              ),
            ),
            const SizedBox(height: 20),

            // ── Nhóm ────────────────────────────────────
            const Text('Nhóm',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textHint)),
            const SizedBox(height: 10),
            Row(
              children: RelativeGroup.values.map((g) {
                final isSel = _group == g;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: g != RelativeGroup.acquaintance ? 8 : 0),
                    child: GestureDetector(
                      onTap: () => setState(() => _group = g),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          color: isSel ? AppTheme.surface : AppTheme.bg,
                          borderRadius:
                          BorderRadius.circular(AppTheme.radiusSmall),
                          border: Border.all(
                            color:
                            isSel ? AppTheme.textPrimary : AppTheme.divider,
                            width: isSel ? 1.5 : 1,
                          ),
                        ),
                        child: Text(
                          g.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                            isSel ? FontWeight.w700 : FontWeight.w500,
                            color: isSel
                                ? AppTheme.textPrimary
                                : AppTheme.textHint,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // ── Nút thêm ────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEE6B6B)),
                child: _saving
                    ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                    : const Text('Thêm người thân'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}