// ============================================================
// Màn Báo cáo: header có con giáp lật ngang bên phải
// WheelPicker
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/enums/relative_group_enum.dart';
import '../../viewmodels/relative_viewmodel/relative_viewmodel.dart';
import '../../viewmodels/transaction_viewmodel/transaction_viewmodel.dart';
import '../../viewmodels/zodiac_viewmodel/zodiac_viewmodel.dart';
import '../shared/app_theme.dart';
import '../shared/tet_scaffold.dart';
import '../shared/transaction_form_sheet.dart';
import '../shared/wheel_picker.dart';
import 'report_day_selector.dart';
import 'report_history_item.dart';
import 'report_trend_chart.dart';
part 'report_filter_button.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});
  @override State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  RelativeGroup? _groupFilter;

  @override
  Widget build(BuildContext context) {
    final txVM     = context.watch<TransactionViewModel>();
    final relVM    = context.watch<RelativeViewModel>();
    final zodiacVM = context.watch<ZodiacViewModel>();
    final animal   = zodiacVM.currentAnimal;

    final txList = txVM.filteredTransactions.where((tx) {
      if (_groupFilter == null) return true;
      try {
        return relVM.relatives
            .firstWhere((r) => r.id == tx.relativeId).group == _groupFilter;
      } catch (_) { return false; }
    }).toList();

    return TetScaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        centerTitle: false,
        title: const Text('Báo cáo',
            style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary, letterSpacing: -0.5)),
        // Con giáp năm nay ở bên phải, lật ngang để nhìn vào trái
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16),
        //     child: Transform(
        //       alignment: Alignment.center,
        //       transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
        //       child: Image.asset(
        //         animal.assetPath,
        //         width: 40, height: 40,
        //         fit: BoxFit.contain,
        //         errorBuilder: (_, __, ___) =>
        //             Text(animal.emoji,
        //                 style: const TextStyle(fontSize: 32)),
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: txVM.isLoading
            ? const Center(child: CircularProgressIndicator(color: AppTheme.red))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 1),
                  const ReportDaySelector(),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ReportTrendChart(
                        transactions: txVM.filteredTransactions),
                  ),
                  const SizedBox(height: 16),
                  // History header + nhóm filter
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Text('Lịch sử',
                            style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800,
                              color: AppTheme.textPrimary)),
                        const Spacer(),
                        _GroupFilterButton(
                          selected:  _groupFilter,
                          onChanged: (g) => setState(() => _groupFilter = g),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: txList.isEmpty
                        ? Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.inbox_outlined,
                                  size: 48, color: AppTheme.divider),
                              const SizedBox(height: 8),
                              Text(
                                txVM.filteredTransactions.isEmpty
                                    ? 'Không có giao dịch nào'
                                    : 'Không có giao dịch nào trong nhóm này',
                                style: const TextStyle(
                                    color: AppTheme.textHint)),
                            ],
                          ))
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                            itemCount: txList.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 6),
                            itemBuilder: (_, i) {
                              final tx = txList[i];
                              String name = '';
                              RelativeGroup? group;
                              try {
                                final r = relVM.relatives
                                    .firstWhere((r) => r.id == tx.relativeId);
                                name = r.name; group = r.group;
                              } catch (_) {}
                              return ReportHistoryItem(
                                transaction: tx,
                                relativeName: name,
                                group: group,
                                onTap: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (_) => TransactionFormSheet(
                                      transaction: tx),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const TransactionFormSheet(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
