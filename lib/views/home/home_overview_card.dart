// ============================================================
// Card tổng quan: Donut chart với Số dư ở giữa
// 3 chỉ số (Nhận, Cho, Số dư) hiển thị bên phải biểu đồ
// ============================================================

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/transaction_viewmodel/transaction_viewmodel.dart';
import '../shared/app_helpers.dart';
import '../shared/app_theme.dart';
import '../shared/app_widgets.dart';
part 'home_overview_widgets.dart';

class HomeOverviewCard extends StatelessWidget {
  const HomeOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(
      builder: (_, txVM, __) {
        final recv    = txVM.totalReceive;
        final give    = txVM.totalGive;
        final balance = txVM.balance;
        final total   = recv + give;

        return AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              // Header gradient
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7F0000), AppTheme.red]),
                  borderRadius: const BorderRadius.only(
                    topLeft:  Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: const Row(
                  children: [
                    Text('🧧', style: TextStyle(fontSize: 16)),
                    SizedBox(width: 8),
                    Text('Tổng quan lì xì',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),

              // Body: chart + stats
              Padding(
                padding: const EdgeInsets.all(16),
                child: total == 0
                    ? _EmptyState()
                    : Row(
                        children: [
                          // ── Donut chart với số dư ở giữa ──
                          SizedBox(
                            width: 140,
                            height: 140,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                PieChart(PieChartData(
                                  sectionsSpace: 3,
                                  centerSpaceRadius: 46,
                                  sections: [
                                    PieChartSectionData(
                                      value: recv,
                                      color: AppTheme.green,
                                      radius: 24,
                                      title: '',
                                    ),
                                    if (give > 0)
                                      PieChartSectionData(
                                        value: give,
                                        color: AppTheme.red,
                                        radius: 24,
                                        title: '',
                                      ),
                                  ],
                                )),
                                // Số dư ở giữa donut
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Số dư',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: AppTheme.textHint,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    FittedBox(
                                      child: Text(
                                        _shortAmount(balance),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w800,
                                          color: balance >= 0
                                              ? AppTheme.green
                                              : AppTheme.red,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 20),

                          // ── 3 chỉ số bên phải ─────────────
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _StatRow(
                                  color: AppTheme.green,
                                  label: 'Tổng nhận',
                                  amount: recv,
                                  pct: total > 0 ? recv / total * 100 : 0,
                                ),
                                const SizedBox(height: 12),
                                _StatRow(
                                  color: AppTheme.red,
                                  label: 'Tổng cho',
                                  amount: give,
                                  pct: total > 0 ? give / total * 100 : 0,
                                ),
                                const Divider(height: 16),
                                _BalanceRow(balance: balance),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  // "1500000" → "1.5tr" để vừa trong donut
  String _shortAmount(double v) {
    if (v.abs() >= 1000000) {
      return '${(v / 1000000).toStringAsFixed(1)}tr';
    } else if (v.abs() >= 1000) {
      return '${(v / 1000).toStringAsFixed(0)}k';
    }
    return v.toStringAsFixed(0);
  }
}

