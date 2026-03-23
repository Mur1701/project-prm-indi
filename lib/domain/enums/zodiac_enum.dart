import 'dart:math';
import 'dart:ui';

enum ZodiacAnimal {
  rat,      // Tý  - 0
  ox,       // Sửu - 1
  tiger,    // Dần - 2
  cat,      // Mão - 3 (VN dùng Mèo thay Thỏ)
  dragon,   // Thìn - 4
  snake,    // Tỵ  - 5
  horse,    // Ngọ - 6
  goat,     // Mùi - 7
  monkey,   // Thân - 8
  rooster,  // Dậu - 9
  dog,      // Tuất - 10
  pig;      // Hợi - 11

  // Tên tiếng Việt
  String get vnName {
    const names = [
      'Tý','Sửu','Dần','Mão','Thìn','Tỵ',
      'Ngọ','Mùi','Thân','Dậu','Tuất','Hợi',
    ];
    return names[index];
  }

  // Tên con vật tiếng Việt
  String get animalName {
    const names = [
      'Chuột','Trâu','Hổ','Mèo','Rồng','Rắn',
      'Ngựa','Dê','Khỉ','Gà','Chó','Lợn',
    ];
    return names[index];
  }

  // Emoji dự phòng khi không load được ảnh
  String get emoji {
    const emojis = [
      '🐭','🐮','🐯','🐱','🐲','🐍',
      '🐴','🐑','🐵','🐓','🐶','🐷',
    ];
    return emojis[index];
  }

  // Asset ảnh từ sheet đã cắt
  String get assetPath {
    const assetNames = [
      'rat','ox','tiger','cat','dragon','snake',
      'horse','goat','monkey','rooster','dog','pig',
    ];
    return 'assets/images/zodiac/${assetNames[index]}.png';
  }

  // Góc độ vị trí trên mặt đồng hồ (0° = top, tính theo chiều kim đồng hồ)
  // Rat (0) = 12h = 0°, Ox (1) = 1h = 30°, ...
  double get clockDegrees => index * 30.0;

  // Vị trí x,y trên circle với radius r, center (cx, cy)
  Offset clockOffset(double cx, double cy, double r) {
    final rad = (clockDegrees - 90) * pi / 180;
    return Offset(cx + cos(rad) * r, cy + sin(rad) * r);
  }

  // Xác định con giáp theo năm dương lịch
  // 2024 = Dragon (index 4) → base
  static ZodiacAnimal forYear(int year) =>
      ZodiacAnimal.values[(year - 2024 + 4) % 12];

  // Tên năm đầy đủ
  static String yearLabel(int year) {
    final animal = forYear(year);
    return '${animal.emoji} $year';
  }
}

// ignore: avoid_classes_with_only_static_members
class ZodiacUtils {
  // Danh sách 12 năm demo từ 2026
  static List<int> get demoYears =>
      List.generate(12, (i) => 2026 + i);
}
