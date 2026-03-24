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
    final Map<int, double> recv = {}, give = {};
    for (final t in transactions) {
      final h = t.dateTime.hour;
      if (t.type == TransactionType.receive) {
        recv[h] = (recv[h] ?? 0) + t.amount;
      } else {
        give[h] = (give[h] ?? 0) + t.amount;
      }
    }

    List<FlSpot> toSpots(Map<int, double> m) => m.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value / 1000))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    final rSpots = toSpots(recv);
    final gSpots = toSpots(give);
    final hasData = rSpots.isNotEmpty || gSpots.isNotEmpty;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Xu hướng theo giờ',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700, // Đậm hơn tiêu đề
                  color: AppTheme.textSecondary)),
          const SizedBox(height: 24),
          SizedBox(
            height: 165, // Tăng nhẹ chiều cao
            child: hasData
                ? LineChart(_chartData(rSpots, gSpots))
                : _EmptyChart(),
          ),
        ],
      ),
    );
  }

  LineChartData _chartData(List<FlSpot> r, List<FlSpot> g) {
    final allSpots = [...r, ...g];
    final realMinX = allSpots.map((s) => s.x).reduce((a, b) => a < b ? a : b);
    final realMaxX = allSpots.map((s) => s.x).reduce((a, b) => a > b ? a : b);

    // Căn lề X thoáng hơn
    final minX = realMinX - 0.8;
    final maxX = realMaxX + 0.8;

    final maxVal = allSpots.isEmpty
        ? 1.0
        : allSpots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    final double calculatedMaxY = maxVal * 1.25;

    return LineChartData(
      minY: 0,
      maxY: calculatedMaxY,
      minX: minX,
      maxX: maxX,
      clipData: const FlClipData.none(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        checkToShowHorizontalLine: (value) => value % 2000 == 0 && value != 0,
        getDrawingHorizontalLine: (value) => FlLine(
          color: AppTheme.divider.withOpacity(0.8), // Grid rõ nét hơn
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 42,
            interval: 1000,
            getTitlesWidget: (v, meta) {
              if (v > maxVal + 10) return const SizedBox.shrink();
              String text = v >= 1000 ? '${(v / 1000).toStringAsFixed(0)}M' : '${v.toInt()}';
              if (v == 0) text = '0';
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 10,
                child: Text(text,
                    style: const TextStyle(
                        fontSize: 11, // Tăng size chữ
                        fontWeight: FontWeight.w600, // Làm chữ rõ hơn
                        color: AppTheme.textSecondary // Màu đậm hơn textHint
                    )),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2, // Hiện giờ mỗi 2 tiếng (8h, 10h, 12h...) cho dày hơn
            getTitlesWidget: (v, meta) {
              // Chỉ hiện nhãn trong phạm vi dữ liệu thực tế
              if (v < realMinX - 0.2 || v > realMaxX + 0.2) return const SizedBox.shrink();
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 12,
                child: Text('${v.toInt()}h',
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textSecondary
                    )),
              );
            },
          ),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        if (r.isNotEmpty) _line(r, AppTheme.green),
        if (g.isNotEmpty) _line(g, AppTheme.red),
      ],
    );
  }

  LineChartBarData _line(List<FlSpot> spots, Color color) => LineChartBarData(
    spots: spots,
    isCurved: true,
    preventCurveOverShooting: true,
    color: color,
    barWidth: 3.5, // Tăng độ dày đường Line một chút cho rõ
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(
      show: true,
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withOpacity(0.18), color.withOpacity(0.01)],
      ),
    ),
  );
}

class _EmptyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final animal = context.watch<ZodiacViewModel>().currentAnimal;
    final w = MediaQuery.of(context).size.width;
    return SizedBox.expand(
      child: Stack(
        children: [
          Positioned(left: 0, bottom: 0, child: Image.asset(animal.assetPath, width: 80, height: 80, errorBuilder: (_, __, ___) => Text(animal.emoji, style: const TextStyle(fontSize: 56)))),
          Positioned(
            left: w * 0.21, bottom: 52,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12), bottomRight: Radius.circular(12)), border: Border.all(color: AppTheme.divider), boxShadow: AppTheme.cardShadow),
              child: const Text('Bạn chưa có lì xì nào :< ', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}