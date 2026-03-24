part of 'splash_page.dart';

// ============================================================
// Phase 2 — Lần tiếp theo:
// Ảnh bao lì xì mặt sau + con giáp + nút Mở
// ============================================================

class _Phase2 extends StatelessWidget {
  final String userName;
  final ZodiacAnimal animal;
  final Animation<double> pulseAnim, glowAnim;
  final VoidCallback onEnter;
  final Size size;

  const _Phase2({
    required this.userName, required this.animal,
    required this.pulseAnim, required this.glowAnim,
    required this.onEnter, required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final topPad     = MediaQuery.of(context).padding.top;
    final w          = size.width;
    final envW       = w * 0.70;
    final envH       = envW * (1521 / 704);
    final envTop     = topPad + 56.0;
    final animalSize = envW * 0.6;

    return Stack(
      clipBehavior: Clip.none,
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

        // ── Ảnh bao lì xì mặt sau ────────────────────────
        Positioned(
          top:  envTop,
          left: (w - envW) / 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/images/envelope_back.png',
              width:  envW,
              height: envH,
              fit:    BoxFit.fill,
            ),
          ),
        ),

        // ── Nút "Mở" ở vị trí bông hoa (~22% từ trên ảnh)
        Positioned(
          top:  envTop + envH * 0.275,
          left: (w - envW) / 2 + envW / 2 - 44,
          child: _OpenButton(pulseAnim: pulseAnim, onTap: onEnter),
        ),

        // ── Con giáp góc dưới-trái bao ───────────────────
        Positioned(
          top:  envTop + envH - animalSize * 0.75,
          left: (w - envW) / 2 - animalSize * 0.15,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                animal.assetPath,
                width:  animalSize,
                height: animalSize,
                fit:    BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    Text(animal.emoji, style: TextStyle(fontSize: animalSize * 0.7)),
              ),
              // Speech bubble phía trên-phải con giáp
              Positioned(
                top:  -(animalSize * 0.55),
                left: animalSize * 0.5,
                child: _SpeechBubble(
                  text:      'Chào $userName! 🎊\nCùng kiểm tra\nlì xì nào!',
                  arrowLeft: true,
                  width:     145,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

