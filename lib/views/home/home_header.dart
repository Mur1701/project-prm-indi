// ============================================================
// Header của màn Trang chủ: tên app + badge năm con giáp
// ============================================================

import 'package:flutter/material.dart';
import '../shared/app_theme.dart';

class HomeHeader extends StatelessWidget {
  final String yearLabel;
  const HomeHeader({required this.yearLabel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          const Text('Lì Xì Tracker',
              style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary, letterSpacing: -0.5)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppTheme.redLight,
              borderRadius: BorderRadius.circular(20)),
            child: Text('$yearLabel',
                style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700,
                  color: AppTheme.red)),
          ),
        ],
      ),
    );
  }
}
