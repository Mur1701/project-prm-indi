// ============================================================
// Một dòng lịch sử giao dịch: icon → số tiền, tên, tag, giờ
// ============================================================

import 'package:flutter/material.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/enums/relative_group_enum.dart';
import '../shared/app_helpers.dart';
import '../shared/app_theme.dart';
import '../shared/app_widgets.dart';

class ReportHistoryItem extends StatelessWidget {
  final Transaction transaction;
  final String relativeName;
  final RelativeGroup? group;
  final VoidCallback onTap;

  const ReportHistoryItem({
    super.key,
    required this.transaction,
    required this.relativeName,
    required this.group,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRecv = transaction.isReceive;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            // Icon mũi tên
            ArrowIcon(isReceive: isRecv),
            const SizedBox(width: 12),

            // Tên + group tag
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Số tiền
                  Text(
                    AppHelpers.formatSigned(transaction.amount, isRecv),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isRecv ? AppTheme.green : AppTheme.red,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Flexible(
                        child: Text(relativeName,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            )),
                      ),
                      if (group != null) ...[
                        const SizedBox(width: 6),
                        GroupTag(group!),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Giờ
            Text(
              AppHelpers.formatTime(transaction.date),
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
