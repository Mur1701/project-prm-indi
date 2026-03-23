// ============================================================
// Biểu đồ đường xu hướng theo giờ trong ngày
// ============================================================

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/enums/transaction_type_enum.dart';
import '../../viewmodels/zodiac_viewmodel/zodiac_viewmodel.dart';
import '../shared/app_theme.dart';
import '../shared/app_widgets.dart';

class ReportTrendChart extends StatelessWidget {
  final List<Transaction> transactions;

  const ReportTrendChart({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Gom tiền theo giờ
    final Map<int, double> recv = {}, give = {};
    for (final t in transactions) {
      final h = t.dateTime.hour;
      if (t.type == TransactionType.receive) {
        recv[h] = (recv[h] ?? 0) + t.amount;
      } else {
        give[h] = (give[h] ?? 0) + t.amount;
      }
    }

    // Tạo FlSpot (đơn vị nghìn đồng)
    List<FlSpot> toSpots(Map<int, double> m) => m.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value / 1000))
        .toList()..sort((a, b) => a.x.compareTo(b.x));

    final rSpots = toSpots(recv);
    final gSpots = toSpots(give);
    final hasData = rSpots.isNotEmpty || gSpots.isNotEmpty;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Xu hướng theo giờ',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textHint)),
          const SizedBox(height: 12),
          SizedBox(
            height: 155,
            child: hasData
                ? ClipRect(child: LineChart(_chartData(rSpots, gSpots)))
                : _EmptyChart(),
          ),
        ],
      ),
    );
  }

  LineChartData _chartData(List<FlSpot> r, List<FlSpot> g) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(
            color: AppTheme.divider, strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 36,
          getTitlesWidget: (v, _) => Text(
              v >= 1000 ? '${(v/1000).toStringAsFixed(0)}M'
                  : '${v.toInt()}k',
              style: const TextStyle(
                  fontSize: 10, color: AppTheme.textHint)),
        )),
        bottomTitles: AxisTitles(sideTitles: SideTitles(
          showTitles: true,
          interval: 2,
          getTitlesWidget: (v, _) => Text(
              '${v.toInt()}h',
              style: const TextStyle(
                  fontSize: 10, color: AppTheme.textHint)),
        )),
        topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        if (r.isNotEmpty) _line(r, AppTheme.green),
        if (g.isNotEmpty) _line(g, AppTheme.red),
      ],
    );
  }

  LineChartBarData _line(List<FlSpot> spots, Color color) =>
      LineChartBarData(
        spots: spots,
        isCurved: true,
        color: color,
        barWidth: 2.5,
        dotData: const FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          color: color.withOpacity(0.07),
        ),
      );
}

// ── Empty state: con giáp nói chuyện ─────────────────────────
class _EmptyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final animal = context.watch<ZodiacViewModel>().currentAnimal;
    final w      = MediaQuery.of(context).size.width;

    return SizedBox.expand(
      child: Stack(
        children: [
          // Con giáp ở vị trí 1/3 từ trái, quay sang phải
          Positioned(
            left: w * 0.1,           // ~1/3 màn hình (card có padding)
            bottom: 0,
            child: Image.asset(
              animal.assetPath,
              width:  80,
              height: 80,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  Text(animal.emoji, style: const TextStyle(fontSize: 56)),
            ),
          ),

          // Speech bubble phía trên-phải con giáp
          Positioned(
            left:   w * 0.25,         // ngay cạnh phải con giáp
            bottom: 65,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft:     Radius.circular(12),
                  topRight:    Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                border: Border.all(color: AppTheme.divider),
                boxShadow: AppTheme.cardShadow,
              ),
              child: const Text(
                'Bạn chưa có lì xì nào :< ',
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
