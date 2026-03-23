// ============================================================
// Ống thẻ bốc lời chúc kiểu truyền thống
// Con giáp năm nay nói: "Bạn chưa có lời chúc sao? Để mình chọn giúp!"
// Tap → animation lắc → hiện câu chúc qua speech bubble
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/enums/zodiac_enum.dart';
import '../../viewmodels/wish_viewmodel/wish_viewmodel.dart';
import '../../viewmodels/zodiac_viewmodel/zodiac_viewmodel.dart';
import '../shared/app_theme.dart';
import '../shared/app_widgets.dart';
part 'home_fortune_widgets.dart';

class HomeFortuneBox extends StatefulWidget {
  const HomeFortuneBox({super.key});

  @override
  State<HomeFortuneBox> createState() => _HomeFortuneBoxState();
}

class _HomeFortuneBoxState extends State<HomeFortuneBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _shakeAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end:  8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _draw() async {
    final wishVM = context.read<WishViewModel>();
    _shakeCtrl.forward(from: 0);
    await wishVM.draw();
  }

  @override
  Widget build(BuildContext context) {
    final zodiac = context.watch<ZodiacViewModel>().currentAnimal;
    final wishVM = context.watch<WishViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Header ────────────────────────────────
            Row(
              children: [
                const Text('🎋', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 8),
                const Text('Ống thẻ lời chúc',
                    style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary)),
                const Spacer(),
                if (wishVM.hasDrawn)
                  TextButton(
                    onPressed: () {
                      wishVM.reset();
                      _shakeCtrl.reset();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.red,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                    ),
                    child: const Text('Bốc lại',
                        style: TextStyle(fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Con giáp + ống thẻ ────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Con giáp nói chuyện
                Expanded(
                  child: _ZodiacTalker(
                    animal:   zodiac,
                    hasDrawn: wishVM.hasDrawn,
                    wish:     wishVM.current?.subtitle,
                  ),
                ),

                const SizedBox(width: 16),

                // Ống thẻ + nút bốc
                Column(
                  children: [
                    AnimatedBuilder(
                      animation: _shakeAnim,
                      builder: (_, child) => Transform.rotate(
                        angle: _shakeAnim.value * pi / 180,
                        child: child,
                      ),
                      child: GestureDetector(
                        onTap: wishVM.isDrawing ? null : _draw,
                        child: _FortuneBarrel(
                            isShaking: wishVM.isDrawing),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      wishVM.isDrawing ? 'Đang bốc...' : 'Nhấn để bốc thẻ',
                      style: const TextStyle(
                          fontSize: 11, color: AppTheme.textHint),
                    ),
                  ],
                ),
              ],
            ),

            // ── Câu chúc hiện ra ──────────────────────
            if (wishVM.hasDrawn && wishVM.current != null) ...[
              const SizedBox(height: 12),
              _WishCard(wish: wishVM.current!),
            ],
          ],
        ),
      ),
    );
  }
}

// Con giáp trong speech bubble
