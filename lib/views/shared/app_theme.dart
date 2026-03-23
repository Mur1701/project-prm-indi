// ============================================================
// Design system toàn app: màu, font size, radius, shadow
// Phong cách: Clean modern + accent Tết (đỏ & vàng nhạt)
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // ── Màu chủ đạo ───────────────────────────────────────────
  static const Color red        = Color(0xFFE51F1F); // Đỏ Tết chính
  static const Color redLight   = Color(0xFFFFF0F0); // Nền đỏ nhạt
  static const Color green      = Color(0xFF1DB954); // Xanh lá tiền vào
  static const Color greenLight = Color(0xFFEBF9F1); // Nền xanh nhạt

  // Alias cho giao dịch (dùng ở chart, history item...)
  static const Color giveColor    = red;   // Tiền cho → đỏ
  static const Color receiveColor = green; // Tiền nhận → xanh

  // Màu trung tính
  static const Color bg         = Color(0xFFF8F9FA); // Nền app
  static const Color surface    = Colors.white;       // Nền card
  static const Color textPrimary   = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF4A4A4A);
  static const Color textHint      = Color(0xFF9E9E9E);
  static const Color divider       = Color(0xFFEEEEEE);

  // Màu nhãn nhóm
  static const Color familyTag     = Color(0xFFFFEBEB); // Gia đình - đỏ nhạt
  static const Color familyText    = Color(0xFFE51F1F);
  static const Color relativesTag  = Color(0xFFFFF3E0); // Họ hàng - cam nhạt
  static const Color relativesText = Color(0xFFE65100);
  static const Color acquaintTag   = Color(0xFFE3F2FD); // Thân quen - xanh nhạt
  static const Color acquaintText  = Color(0xFF1565C0);

  // ── Border radius ─────────────────────────────────────────
  static const double radiusCard   = 16;
  static const double radiusSmall  = 8;
  static const double radiusButton = 50; // Stadium shape

  // ── Shadow nhẹ cho card ───────────────────────────────────
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  // ── ThemeData ─────────────────────────────────────────────
  static ThemeData get theme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: red,
      primary: red,
      secondary: green,
    ),
    scaffoldBackgroundColor: bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        letterSpacing: -0.3,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusButton),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: red,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: CircleBorder(),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: red,
      unselectedItemColor: textHint,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(fontSize: 11),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bg,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
        borderSide: const BorderSide(color: divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
        borderSide: const BorderSide(color: divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusSmall),
        borderSide: const BorderSide(color: red, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: const TextStyle(color: textHint, fontSize: 14),
    ),
    dividerTheme: const DividerThemeData(
      color: divider,
      thickness: 1,
      space: 0,
    ),
    useMaterial3: true,
  );
}
