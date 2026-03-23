// ============================================================
// 4 tab: Trang chủ | Báo cáo | Người thân | Cài đặt
// ============================================================

import 'package:flutter/material.dart';

import 'home/home_page.dart';
import 'relative/relative_form_dialog.dart';
import 'relative/relative_page.dart';
import 'report/report_page.dart';
import 'settings/settings_page.dart';
import 'shared/app_theme.dart';
import 'shared/transaction_form_sheet.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  static const _pages = [
    HomePage(),
    ReportPage(),
    RelativePage(),
    SettingsPage(),
  ];

  void _onFab() {
    if (_index == 2) {
      // Người thân → thêm người thân
      showDialog(context: context,
          builder: (_) => const RelativeFormDialog());
    } else if (_index == 3) {
      // Cài đặt → không có FAB
      return;
    } else {
      // Home / Báo cáo → thêm giao dịch
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const TransactionFormSheet(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      floatingActionButton: _index != 3
          ? FloatingActionButton(
              onPressed: _onFab,
              child: const Icon(Icons.add, size: 28))
          : null,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          border: Border(top: BorderSide(color: AppTheme.divider, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart_outlined),
              activeIcon: Icon(Icons.insert_chart),
              label: 'Báo cáo',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              activeIcon: Icon(Icons.group),
              label: 'Người thân',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Cài đặt',
            ),
          ],
        ),
      ),
    );
  }
}
