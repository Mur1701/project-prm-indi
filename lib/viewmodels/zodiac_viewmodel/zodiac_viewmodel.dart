// ============================================================
// Quản lý năm được chọn (demo dropdown 2026-2037)
// và thông tin con giáp tương ứng
// ============================================================

import 'package:flutter/foundation.dart';
import '../../domain/enums/zodiac_enum.dart';

class ZodiacViewModel extends ChangeNotifier {
  int _year = 2026;

  int get selectedYear => _year;

  ZodiacAnimal get currentAnimal => ZodiacAnimal.forYear(_year);

  String get yearLabel => ZodiacAnimal.yearLabel(_year);

  List<int> get availableYears => ZodiacUtils.demoYears;

  void selectYear(int year) {
    if (_year == year) return;
    _year = year;
    notifyListeners();
  }
}
