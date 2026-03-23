// ============================================================
// Dùng package 'marquee' thay code cuộn thủ công
// Hiển thị Top 3 người lì xì nhiều nhất
// ============================================================

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/transaction.dart';
import '../../viewmodels/relative_viewmodel/relative_viewmodel.dart';
import '../../viewmodels/transaction_viewmodel/transaction_viewmodel.dart';
import '../shared/app_helpers.dart';
import '../shared/app_theme.dart';

class HomeMarqueeBanner extends StatelessWidget {
  const HomeMarqueeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final txVM  = context.watch<TransactionViewModel>();
    final relVM = context.watch<RelativeViewModel>();

    // Top 3 người receive nhiều nhất
    final top3 = _getTop3(txVM.transactions, relVM);
    if (top3.isEmpty) return const SizedBox.shrink();

    // Tạo chuỗi cuộn: "🥇 Bố mẹ  2.000.000đ   |   🥈 ..."
    final text = top3.asMap().entries.map((e) {
      final rank = e.key + 1;
      return 'TOP $rank  ${e.value.$1}:  ${AppHelpers.formatCurrency(e.value.$2)}';
    }).join('        |        ');

    return Container(
      height: 34,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.red.withOpacity(0.08),
            AppTheme.red.withOpacity(0.14),
            AppTheme.red.withOpacity(0.08),
          ],
        ),
        border: Border.symmetric(
          horizontal: BorderSide(
              color: AppTheme.red.withOpacity(0.12), width: 1),
        ),
      ),
      child: Row(
        children: [
          // Badge "TOP"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.center,
            color: AppTheme.red,
            child: const Text(
              'TOP',
              style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w800,
                color: Colors.white, letterSpacing: 0.5,
              ),
            ),
          ),

          // Marquee cuộn từ package
          Expanded(
            child: Marquee(
              text:                  text,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.red.withOpacity(0.85),
              ),
              scrollAxis:            Axis.horizontal,
              crossAxisAlignment:    CrossAxisAlignment.center,
              blankSpace:            80,
              velocity:              40,           // pixel/giây
              pauseAfterRound:       const Duration(seconds: 1),
              fadingEdgeStartFraction: 0.05,
              fadingEdgeEndFraction: 0.05,
              startAfter:            const Duration(milliseconds: 500),
            ),
          ),
        ],
      ),
    );
  }

  List<(String, double)> _getTop3(
    List<Transaction> txs, RelativeViewModel relVM) {
    final Map<int, double> totals = {};
    for (final t in txs) {
      if (t.isReceive) {
        totals[t.relativeId] = (totals[t.relativeId] ?? 0) + t.amount;
      }
    }
    final sorted = totals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(3).map((e) {
      String name = '?';
      try {
        name = relVM.relatives.firstWhere((r) => r.id == e.key).name;
      } catch (_) {}
      return (name, e.value);
    }).toList();
  }
}
