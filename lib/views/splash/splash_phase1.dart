part of 'splash_page.dart';

// ============================================================
// Phase 1 — Lần đầu mở app:
// Ảnh bao lì xì con ếch + speech bubble + ô nhập tên
// ============================================================

class _Phase1 extends StatelessWidget {
  final TextEditingController nameCtrl;
  final Animation<double> pulseAnim, glowAnim;
  final VoidCallback onConfirm;
  final Size size;

  const _Phase1({
    required this.nameCtrl, required this.pulseAnim,
    required this.glowAnim, required this.onConfirm, required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final kb     = MediaQuery.of(context).viewInsets.bottom;
    final w      = size.width;
    final h      = size.height;
    // Ảnh bao chiếm 70% chiều rộng, tỉ lệ 704:1519
    final envW   = w * 0.70;
    final envH   = envW * (1519 / 704);
    // Đặt ảnh bao ở giữa theo chiều ngang, bắt đầu từ dưới title
    final topPad = MediaQuery.of(context).padding.top;
    final envTop = topPad + 56.0; // dưới title

    return Stack(
      children: [
        // ── Tiêu đề ──────────────────────────────────────
        Positioned(
          top: topPad + 12,
          left: 0, right: 0,
          child: AnimatedBuilder(
            animation: glowAnim,
            builder: (_, __) => _AppTitle(glowValue: glowAnim.value),
          ),
        ),

        // ── Ảnh bao lì xì con ếch ở giữa ────────────────
        Positioned(
          top:  envTop,
          left: (w - envW) / 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/images/envelope_front.png',
              width:  envW,
              height: envH,
              fit:    BoxFit.fill,
            ),
          ),
        ),

        // ── Speech bubble gắn vào vùng con ếch (giữa ảnh)
        Positioned(
          top:  envTop + envH * 0.30,
          left: (w - envW) / 2 + envW * 0.55,
          child: const _SpeechBubble(
            text:      'Xin chào! 👋\nBạn tên là gì nhỉ???',
            arrowLeft: true,
            width:     145,
          ),
        ),

        // ── Ô nhập tên đè lên phần dưới ảnh lì xì ───────
        // Nằm giữa vùng con ếch và đáy ảnh (~75% chiều cao ảnh)
        Positioned(
          top:   envTop + envH * 0.72,
          left:  (w - envW) / 2 + 12,
          right: (w - envW) / 2 + 12,
          child: _NameField(
            ctrl:      nameCtrl,
            pulseAnim: pulseAnim,
            onConfirm: onConfirm,
          ),
        ),

        // Khi bàn phím mở → dịch ô nhập tên lên trên
        if (kb > 0)
          Positioned(
            bottom: kb + 16,
            left: 20, right: 20,
            child: _NameField(
              ctrl:      nameCtrl,
              pulseAnim: pulseAnim,
              onConfirm: onConfirm,
            ),
          ),
      ],
    );
  }
}

