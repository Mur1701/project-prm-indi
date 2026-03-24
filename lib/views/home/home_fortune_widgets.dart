part of 'home_fortune_box.dart';

// ============================================================
// Các widget nhỏ trong ống thẻ lời chúc:
//   _ZodiacTalker, _FortuneBarrel, _BarrelPainter, _WishCard
// ============================================================

class _ZodiacTalker extends StatelessWidget {
  final ZodiacAnimal animal;
  final bool hasDrawn;
  final String? wish;

  const _ZodiacTalker({
    required this.animal,
    required this.hasDrawn,
    this.wish,
  });

  @override
  Widget build(BuildContext context) {
    final msg = hasDrawn
        ? '✨ Đây là lời chúc dành cho bạn!'
        : 'Bạn chưa nghĩ ra lời chúc sao? Để ${animal.vnName} chọn giúp một câu nhé!';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Speech bubble
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Text(msg,
              style: const TextStyle(
                fontSize: 12, color: AppTheme.textSecondary, height: 1.4)),
        ),
        const SizedBox(height: 6),
        // Avatar con giáp
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(animal.assetPath, width: 80, height: 80,
                errorBuilder: (_, __, ___) =>
                    Text(animal.emoji,
                        style: const TextStyle(fontSize: 32))),
            const SizedBox(width: 4),
            Text(animal.animalName,
                style: const TextStyle(
                    fontSize: 11, color: AppTheme.textHint)),
          ],
        ),
      ],
    );
  }
}

// Ống thẻ vẽ bằng CustomPainter
class _FortuneBarrel extends StatelessWidget {
  final bool isShaking;
  const _FortuneBarrel({required this.isShaking});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(60, 80),
      painter: _BarrelPainter(isShaking: isShaking),
    );
  }
}

class _BarrelPainter extends CustomPainter {
  final bool isShaking;
  _BarrelPainter({required this.isShaking});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;

    // Thân ống - màu gỗ
    final body = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFFC8956C), const Color(0xFF8B5E3C)],
      ).createShader(Rect.fromLTWH(0, h * 0.25, w, h * 0.75));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(w * 0.1, h * 0.3, w * 0.8, h * 0.65),
          Radius.circular(w * 0.12)),
      body,
    );

    // Vành ống
    final rim = Paint()
      ..color = const Color(0xFF5D3A1A)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.1, h * 0.52),
        Offset(w * 0.9, h * 0.52), rim);

    // Que thẻ (5 que nhỏ)
    final stick = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFFD4A850), const Color(0xFF8B6914)],
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.45));
    for (int i = 0; i < 5; i++) {
      final x = w * 0.2 + i * w * 0.14;
      final lean = (i - 2) * 0.08;
      canvas.save();
      canvas.translate(x, h * 0.3);
      canvas.rotate(lean);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(-3, -h * 0.28, 6, h * 0.3),
            const Radius.circular(3)),
        stick,
      );
      // Đầu que đỏ
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(-3, -h * 0.28, 6, h * 0.06),
            const Radius.circular(3)),
        Paint()..color = const Color(0xFFD32F2F),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_BarrelPainter old) => old.isShaking != isShaking;
}

// Card hiển thị câu chúc được bốc ra
class _WishCard extends StatelessWidget {
  final wish;
  const _WishCard({required this.wish});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 400),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF8E1), Color(0xFFFFF3CD)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Text('✨', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(wish.title,
                  style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w700,
                    color: Color(0xFF8B5E00))),
            ]),
            const SizedBox(height: 6),
            Text(wish.subtitle,
                style: const TextStyle(
                  fontSize: 13, color: AppTheme.textSecondary, height: 1.5)),
          ],
        ),
      ),
    );
  }
}
