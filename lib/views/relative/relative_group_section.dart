// ============================================================
// Một phần nhóm: header nhóm + danh sách người trong nhóm
// ============================================================

import 'package:flutter/material.dart';
import '../../domain/entities/relative.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/enums/relative_group_enum.dart';
import '../shared/app_theme.dart';
import 'relative_item_row.dart';

class RelativeGroupSection extends StatelessWidget {
  final RelativeGroup group;
  final List<Relative> members;
  final List<Transaction> allTransactions;
  final void Function(int id) onDelete;

  const RelativeGroupSection({
    super.key,
    required this.group,
    required this.members,
    required this.allTransactions,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header nhóm
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Text(
                group.value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _groupColor(group),
                ),
              ),
            ),

            // Divider mỏng
            Divider(height: 1, color: AppTheme.divider.withOpacity(0.5)),

            // Các dòng người thân
            ...members.asMap().entries.map((e) {
              final rel = e.value;
              final isLast = e.key == members.length - 1;

              // Tính tổng tiền nhận - cho với người này
              final txs = allTransactions
                  .where((t) => t.relativeId == rel.id);
              final recv = txs
                  .where((t) => t.isReceive)
                  .fold(0.0, (s, t) => s + t.amount);
              final give = txs
                  .where((t) => !t.isReceive)
                  .fold(0.0, (s, t) => s + t.amount);

              return Column(
                children: [
                  RelativeItemRow(
                    relative: rel,
                    group: group,
                    netAmount: recv - give,
                    onDelete: () => onDelete(rel.id),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 60,
                      color: AppTheme.divider.withOpacity(0.5),
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _groupColor(RelativeGroup g) {
    switch (g) {
      case RelativeGroup.family:      return AppTheme.familyText;
      case RelativeGroup.relatives:   return AppTheme.relativesText;
      case RelativeGroup.acquaintance: return AppTheme.acquaintText;
    }
  }
}
