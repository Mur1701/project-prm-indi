part of 'splash_page.dart';

// ============================================================
// Các widget nhỏ dùng chung trong màn Splash:
// _NameField, _AppTitle, _OpenButton, _SpeechBubble, _BackSimple
// ============================================================

class _NameField extends StatelessWidget {
  final TextEditingController ctrl;
  final Animation<double> pulseAnim;
  final VoidCallback onConfirm;
  const _NameField({required this.ctrl, required this.pulseAnim, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD54F), width: 2),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: ctrl,
              textAlign: TextAlign.center,
              textCapitalization: TextCapitalization.words,
              style: const TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700, color: AppTheme.red),
              decoration: const InputDecoration(
                hintText: 'Nhập tên của bạn...',
                hintStyle: TextStyle(fontSize: 14, color: Color(0xFFEF9A9A)),
                border: InputBorder.none, enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none, filled: false,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              ),
              onSubmitted: (_) => onConfirm(),
            ),
          ),
          // Nút Xác nhận — màu đỏ, gọn
          AnimatedBuilder(
            animation: pulseAnim,
            builder: (_, child) => Transform.scale(scale: pulseAnim.value, child: child),
            child: GestureDetector(
              onTap: onConfirm,
              child: Container(
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                decoration: BoxDecoration(
                  color: AppTheme.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tiêu đề app glow ─────────────────────────────────────────
class _AppTitle extends StatelessWidget {
  final double glowValue;
  const _AppTitle({required this.glowValue});
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text('🧧', style: TextStyle(fontSize: 22)),
      const SizedBox(width: 6),
      Text('Lì Xì Tracker', style: TextStyle(
        fontSize: 26, fontWeight: FontWeight.w900,
        color: const Color(0xFFFFD54F),
        shadows: [
          Shadow(color: const Color(0xFFFF6F00).withOpacity(glowValue), blurRadius: 18),
          const Shadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2)),
        ],
      )),
    ],
  );
}

// ── Nút Mở lì xì vàng tròn ───────────────────────────────────
class _OpenButton extends StatelessWidget {
  final Animation<double> pulseAnim;
  final VoidCallback onTap;
  const _OpenButton({required this.pulseAnim, required this.onTap});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: pulseAnim,
    builder: (_, child) => Transform.scale(scale: pulseAnim.value, child: child),
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 88, height: 88,
        decoration: BoxDecoration(
          gradient: const RadialGradient(
              colors: [Color(0xFFFFE500), Color(0xFFFF9100)]),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(
            color: const Color(0xFFFF6F00).withOpacity(0.65),
            blurRadius: 20, spreadRadius: 3)],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🧧', style: TextStyle(fontSize: 26)),
            Text('Mở', style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF7F0000))),
          ],
        ),
      ),
    ),
  );
}

// ── Speech bubble ─────────────────────────────────────────────
class _SpeechBubble extends StatelessWidget {
  final String text;
  final bool   arrowLeft;
  final double width;
  const _SpeechBubble({required this.text, this.arrowLeft = false, this.width = 155});

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    padding: const EdgeInsets.fromLTRB(12, 9, 12, 9),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.97),
      borderRadius: BorderRadius.only(
        topLeft:     const Radius.circular(12),
        topRight:    const Radius.circular(12),
        bottomLeft:  Radius.circular(arrowLeft ? 2 : 12),
        bottomRight: Radius.circular(arrowLeft ? 12 : 2),
      ),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 8)],
      border: Border.all(color: const Color(0xFFFFD54F).withOpacity(0.8), width: 1.5),
    ),
    child: Text(text, style: const TextStyle(
      fontSize: 12.5, color: Color(0xFF1A1A1A), height: 1.45, fontWeight: FontWeight.w500)),
  );
}

// ── Ảnh mặt sau đơn giản dùng trong flip transition ──────────
class _BackSimple extends StatelessWidget {
  final Size size;
  const _BackSimple({required this.size});
  @override
  Widget build(BuildContext context) {
    final envW = size.width * 0.70;
    final envH = envW * (1521 / 704);
    final topPad = MediaQuery.of(context).padding.top;
    return SizedBox(
      width: size.width, height: size.height,
      child: Stack(children: [
        Positioned(
          top:  topPad + 56,
          left: (size.width - envW) / 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/images/envelope_back.png',
              width: envW, height: envH, fit: BoxFit.fill),
          ),
        ),
      ]),
    );
  }
}
