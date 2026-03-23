// ============================================================
// Scaffold có nền Tết: ảnh tet_bg.png làm layer dưới cùng
// opacity nhẹ để không che UI, chỉ tạo không khí Tết
// Tất cả màn chính (Home, Report, Relatives, Settings) dùng widget này
// ============================================================

import 'package:flutter/material.dart';

class TetScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Color bgColor;
  final double bgOpacity; // opacity của lớp ảnh nền

  const TetScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bgColor = const Color(0xFFF8F9FA),
    this.bgOpacity = 0.06, // rất nhẹ để không che nội dung
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          // ── Nền màu chính ───────────────────────────
          Container(color: bgColor),

          // ── Lớp ảnh Tết mờ nhẹ ─────────────────────
          Positioned.fill(
            child: Opacity(
              opacity: bgOpacity,
              child: Image.asset(
                'assets/images/tet_bg.png',
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
              ),
            ),
          ),

          // ── Nội dung chính ──────────────────────────
          body,
        ],
      ),
    );
  }
}
