// ============================================================
// Entry point - init locale, setup DI, vào SplashPage
// ============================================================

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'di.dart';
import 'views/shared/app_theme.dart';
import 'views/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('vi_VN', null);
  runApp(const LiXiTrackerApp());
}

class LiXiTrackerApp extends StatelessWidget {
  const LiXiTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return setupDI(
      child: MaterialApp(
        title:                  'Lì Xì Tracker',
        debugShowCheckedModeBanner: false,
        theme:                  AppTheme.theme,
        home:                   const SplashPage(),
      ),
    );
  }
}
