// ============================================================
// Một dòng người thân: avatar, tên, group tag, net amount, menu
// ============================================================

import 'package:flutter/material.dart';
import '../../domain/entities/relative.dart';
import '../../domain/enums/relative_group_enum.dart';
import '../shared/app_helpers.dart';
import '../shared/app_theme.dart';
import '../shared/app_widgets.dart';

class RelativeItemRow extends StatelessWidget {
  final Relative relative;
  final RelativeGroup group;
  final double netAmount; // dương = nhận nhiều hơn, âm = cho nhiều hơn
  final VoidCallback onDelete;

  const RelativeItemRow({
    super.key,
    required this.relative,
    required this.group,
    required this.netAmount,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = netAmount >= 0;
    final amountColor = netAmount == 0
        ? AppTheme.textHint
        : (isPositive ? AppTheme.green : AppTheme.red);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // ── Avatar vòng tròn xám ─────────────────────
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppTheme.bg,
              shape: BoxShape.circle,
              border: Border.all(color: AppTheme.divider),
            ),
            child: const Icon(
              Icons.person_outline,
              size: 20,
              color: AppTheme.textHint,
            ),
          ),
          const SizedBox(width: 12),

          // ── Tên + nhãn nhóm ──────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  relative.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Wrap(
                  spacing: 6, runSpacing: 2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    GroupTag(group),
                    // Số tiền net
                    Text(
                      netAmount == 0
                          ? '0 đ'
                          : AppHelpers.formatSigned(
                              netAmount.abs(), isPositive),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: amountColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Menu "⋮" ─────────────────────────────────
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              size: 18,
              color: AppTheme.textHint,
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline,
                        size: 18, color: AppTheme.red),
                    SizedBox(width: 10),
                    Text('Xóa',
                        style: TextStyle(color: AppTheme.red)),
                  ],
                ),
              ),
            ],
            onSelected: (v) {
              if (v == 'delete') onDelete();
            },
          ),
        ],
      ),
    );
  }
}
