part of 'home_overview_card.dart';

// ============================================================
// Các widget nhỏ trong card tổng quan:
//   _StatRow, _BalanceRow, _EmptyState
// ============================================================

class _StatRow extends StatelessWidget {
  final Color color;
  final String label;
  final double amount;
  final double pct;

  const _StatRow({
    required this.color, required this.label,
    required this.amount, required this.pct,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 7),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: const TextStyle(
                      fontSize: 11, color: AppTheme.textHint)),
                  Text('${pct.toStringAsFixed(0)}%',
                      style: TextStyle(fontSize: 10,
                          color: color.withOpacity(0.8))),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                AppHelpers.formatCurrency(amount),
                style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, color: color),
              ),
              const SizedBox(height: 3),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: pct / 100,
                  backgroundColor: color.withOpacity(0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BalanceRow extends StatelessWidget {
  final double balance;
  const _BalanceRow({required this.balance});

  @override
  Widget build(BuildContext context) {
    final color = balance >= 0 ? AppTheme.green : AppTheme.red;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Số dư',
            style: TextStyle(fontSize: 12,
                color: AppTheme.textHint, fontWeight: FontWeight.w500)),
        Flexible(
          child: FittedBox(
            child: Text(
              AppHelpers.formatCurrency(balance.abs()),
              style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w800, color: color),
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(child: Column(children: [
        Text('🧧', style: TextStyle(fontSize: 48)),
        SizedBox(height: 8),
        Text('Chưa có giao dịch nào\nThêm lì xì đầu tiên!',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textHint, height: 1.5)),
      ])),
    );
  }
}
