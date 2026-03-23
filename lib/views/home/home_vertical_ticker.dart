// ============================================================
// Ticker dọc cuộn lên — dùng Marquee (vertical axis)
// Hiển thị tất cả người đã lì xì cho mình
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/transaction.dart';
import '../../viewmodels/relative_viewmodel/relative_viewmodel.dart';
import '../../viewmodels/transaction_viewmodel/transaction_viewmodel.dart';
import '../shared/app_helpers.dart';
import '../shared/app_theme.dart';
import '../shared/app_widgets.dart';

class HomeVerticalTicker extends StatelessWidget {
  const HomeVerticalTicker({super.key});

  @override
  Widget build(BuildContext context) {
    final txVM  = context.watch<TransactionViewModel>();
    final relVM = context.watch<RelativeViewModel>();

    final receives = txVM.filteredTransactions
        .where((t) => t.isReceive)
        .toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    if (receives.isEmpty) return const SizedBox.shrink();

    // Xây dựng text dạng dọc: mỗi item cách nhau bằng newline + padding
    // Dùng Marquee theo Axis.vertical
    // Mỗi dòng: "💰 Tên  +Số tiền"
    final lines = receives.map((tx) {
      String name = 'Không rõ';
      try {
        name = relVM.relatives
            .firstWhere((r) => r.id == tx.relativeId).name;
      } catch (_) {}
      return '💰  $name   +${AppHelpers.formatCurrency(tx.amount)}';
    }).join('\n\n');

    // Marquee vertical có thể không hỗ trợ tốt — dùng custom scroll thay
    // → dùng PageView + AnimatedSwitcher cho từng item
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: const BorderRadius.only(
                topLeft:  Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                  bottom: BorderSide(color: AppTheme.divider)),
            ),
            child: Row(
              children: [
                const Text('💝', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                const Text('Lì xì nhận được',
                    style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary)),
                const Spacer(),
                Text('${receives.length} người',
                    style: const TextStyle(
                        fontSize: 11, color: AppTheme.textHint)),
              ],
            ),
          ),

          // Ticker: dùng _VerticalAutoScroll
          SizedBox(
            height: 58 * 3.2,
            child: _VerticalAutoScroll(items: receives, relVM: relVM),
          ),
        ],
      ),
    );
  }
}

// ListView tự cuộn lên liên tục — đơn giản, không dùng CustomPainter
class _VerticalAutoScroll extends StatefulWidget {
  final List<Transaction> items;
  final RelativeViewModel relVM;

  const _VerticalAutoScroll({required this.items, required this.relVM});

  @override
  State<_VerticalAutoScroll> createState() => _VerticalAutoScrollState();
}

class _VerticalAutoScrollState extends State<_VerticalAutoScroll> {
  final _ctrl = ScrollController();
  static const double _itemH = 58.0;

  @override
  void initState() {
    super.initState();
    // Đợi build xong rồi bắt đầu cuộn
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScroll());
  }

  Future<void> _startScroll() async {
    while (mounted) {
      await Future.delayed(const Duration(milliseconds: 25));
      if (!mounted || !_ctrl.hasClients) continue;
      final max = _ctrl.position.maxScrollExtent;
      if (max <= 0) continue;
      final next = _ctrl.offset + 0.7;
      if (next >= max) {
        _ctrl.jumpTo(0); // quay về đầu
      } else {
        _ctrl.jumpTo(next);
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Nhân đôi list để tạo cảm giác cuộn vô hạn
    final doubled = [...widget.items, ...widget.items];

    return ClipRect(
      child: ListView.builder(
        controller:  _ctrl,
        physics:     const NeverScrollableScrollPhysics(),
        itemCount:   doubled.length,
        itemExtent:  _itemH,
        itemBuilder: (_, i) {
          final tx = doubled[i];
          String name = 'Không rõ';
          try {
            name = widget.relVM.relatives
                .firstWhere((r) => r.id == tx.relativeId).name;
          } catch (_) {}
          return _TickerRow(name: name, amount: tx.amount);
        },
      ),
    );
  }
}

class _TickerRow extends StatelessWidget {
  final String name;
  final double amount;
  const _TickerRow({required this.name, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppTheme.greenLight,
              shape: BoxShape.circle,
              border: Border.all(
                  color: AppTheme.green.withOpacity(0.3)),
            ),
            child: const Center(
                child: Text('🧧', style: TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary)),
          ),
          Text(
            '+${AppHelpers.formatCurrency(amount)}',
            style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w700,
              color: AppTheme.green),
          ),
        ],
      ),
    );
  }
}
