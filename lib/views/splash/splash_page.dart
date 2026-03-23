// ============================================================
// Nền: tet_bg.png fill toàn màn hình (cả 2 phase)
//
// PHASE 1 — lần đầu:
//   • Ảnh bao lì xì con ếch ở giữa màn, không fill toàn màn
//   • Speech bubble hỏi tên gắn vào vùng con ếch
//   • Ô nhập tên nằm giữa con ếch và đáy ảnh (đè lên ảnh)
//   • Chỉ cần nhấn Enter hoặc nút "Xác nhận" màu đỏ
//
// PHASE 2 — lần sau:
//   • Ảnh bao lì xì mặt sau ở giữa màn
//   • Con giáp góc dưới-trái (2/3 trên bao, 1/3 tràn ra)
//   • Speech bubble gắn liền con giáp
//   • Nút "Mở lì xì" vàng ở vị trí bông hoa
// ============================================================

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/enums/zodiac_enum.dart';
import '../../viewmodels/relative_viewmodel/relative_viewmodel.dart';
import '../../viewmodels/transaction_viewmodel/transaction_viewmodel.dart';
import '../../viewmodels/wish_viewmodel/wish_viewmodel.dart';
import '../../viewmodels/zodiac_viewmodel/zodiac_viewmodel.dart';
import '../main_page.dart';

import '../shared/app_theme.dart';
import '../shared/form_validators.dart';
part 'splash_widgets.dart';
part 'splash_phase1.dart';
part 'splash_phase2.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  String? _userName;
  bool    _loading = true;
  bool    _isBack  = false;
  final   _nameCtrl = TextEditingController();

  late AnimationController _entryCtrl, _flipCtrl, _pulseCtrl, _glowCtrl;
  late Animation<double>   _fadeAnim, _flipAnim, _pulseAnim, _glowAnim;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim  = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeIn);

    _flipCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _flipAnim  = Tween<double>(begin: 0, end: pi)
        .animate(CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOutCubic));

    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.07)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _glowCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);
    _glowAnim  = Tween<double>(begin: 0.3, end: 1.0)
        .animate(CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut));

    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final name  = prefs.getString('user_name');
    setState(() { _userName = name; _isBack = name != null; _loading = false; });
    _entryCtrl.forward();
  }

  Future<void> _confirmName() async {
    final err = FormValidators.userName(_nameCtrl.text.trim());
    if (err != null) {
      /* showSnackBar */
      return;
    }
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    FocusScope.of(context).unfocus();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    setState(() => _userName = name);
    await _flipCtrl.forward();
    setState(() => _isBack = true);
  }

  Future<void> _enter() async {
    if (!mounted) return;
    await Future.wait([
      context.read<TransactionViewModel>().loadTransactions(),
      context.read<RelativeViewModel>().loadRelatives(),
      context.read<WishViewModel>().loadWishes(),
    ]);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder:        (_, __, ___) => const MainPage(),
      transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 400),
    ));
  }

  @override
  void dispose() {
    _entryCtrl.dispose(); _flipCtrl.dispose();
    _pulseCtrl.dispose(); _glowCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppTheme.red,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    final animal = context.watch<ZodiacViewModel>().currentAnimal;
    final size   = MediaQuery.of(context).size;

    return Scaffold(
      // Không resize — dùng resizeToAvoidBottomInset: false
      // ô nhập tên tự dịch chuyển bằng Positioned + viewInsets
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // ── Lớp 1: Nền tet_bg.png fill toàn màn ──────
          Positioned.fill(
            child: Image.asset(
              'assets/images/tet_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // ── Lớp 2: Overlay đỏ nhẹ để đồng nhất màu ──
          Positioned.fill(
            child: Container(
              color: const Color(0xFFC62828).withOpacity(0.45),
            ),
          ),

          // ── Lớp 3: Nội dung chính ─────────────────────
          FadeTransition(
            opacity: _fadeAnim,
            child: _isBack
                ? _Phase2(
                    userName:  _userName ?? 'bạn',
                    animal:    animal,
                    pulseAnim: _pulseAnim,
                    glowAnim:  _glowAnim,
                    onEnter:   _enter,
                    size:      size,
                  )
                : _buildFlip(size),
          ),
        ],
      ),
    );
  }

  Widget _buildFlip(Size size) {
    return AnimatedBuilder(
      animation: _flipAnim,
      builder: (_, __) {
        final angle     = _flipAnim.value;
        final showFront = angle <= pi / 2;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: showFront
              ? _Phase1(
                  nameCtrl:  _nameCtrl,
                  pulseAnim: _pulseAnim,
                  glowAnim:  _glowAnim,
                  onConfirm: _confirmName,
                  size:      size,
                )
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(pi),
                  child: _BackSimple(size: size),
                ),
        );
      },
    );
  }
}
