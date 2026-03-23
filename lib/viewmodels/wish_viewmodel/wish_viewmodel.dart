// ============================================================
// Quản lý state câu chúc: load tất cả + bốc ngẫu nhiên
// ============================================================

import 'package:flutter/foundation.dart';
import '../../data/implementations/repositories/wish_repository.dart';
import '../../domain/entities/wish.dart';

class WishViewModel extends ChangeNotifier {
  final WishRepository _repo;
  WishViewModel(this._repo);

  // ── State ─────────────────────────────────────────────────
  List<Wish> _wishes = [];
  Wish? _current;        // Câu chúc đang hiển thị
  bool _isDrawing = false;
  bool _hasDrawn  = false;

  // ── Getters ───────────────────────────────────────────────
  Wish?  get current   => _current;
  bool   get isDrawing => _isDrawing;
  bool   get hasDrawn  => _hasDrawn;
  int    get total     => _wishes.length;

  Future<void> loadWishes() async {
    _wishes = await _repo.getAll();
    notifyListeners();
  }

  // Bốc ngẫu nhiên 1 câu chúc với animation delay
  Future<void> draw() async {
    if (_wishes.isEmpty) return;
    _isDrawing = true;
    _hasDrawn  = false;
    notifyListeners();

    // Giả lập thời gian "lắc ống thẻ"
    await Future.delayed(const Duration(milliseconds: 900));

    _current   = await _repo.getRandom();
    _isDrawing = false;
    _hasDrawn  = true;
    notifyListeners();
  }

  void reset() {
    _current  = null;
    _hasDrawn = false;
    notifyListeners();
  }
}
