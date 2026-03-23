// ============================================================
// Tab Trang chủ với nền Tết, marquee, dropdown, chart, ticker
// 3 thẻ stat riêng gộp vào chart
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/transaction_viewmodel/transaction_viewmodel.dart';
import '../../viewmodels/wish_viewmodel/wish_viewmodel.dart';
import '../../viewmodels/zodiac_viewmodel/zodiac_viewmodel.dart';
import '../shared/app_theme.dart';
import '../shared/tet_scaffold.dart';
import 'home_day_dropdown.dart';
import 'home_fortune_box.dart';
import 'home_header.dart';
import 'home_marquee_banner.dart';
import 'home_overview_card.dart';
import 'home_vertical_ticker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishViewModel>().loadWishes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final zodiac = context.watch<ZodiacViewModel>();

    return TetScaffold(
      body: SafeArea(
        child: Consumer<TransactionViewModel>(
            builder: (_, txVM, __) {
              if (txVM.isLoading) {
                return const Center(
                    child: CircularProgressIndicator(color: AppTheme.red));
              }
              return RefreshIndicator(
                color: AppTheme.red,
                onRefresh: txVM.loadTransactions,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 100),
                  children: [
                    // Header
                    HomeHeader(yearLabel: zodiac.yearLabel),
                    // Marquee top 3
                    const HomeMarqueeBanner(),
                    const SizedBox(height: 12),
                    // Dropdown chọn năm + ngày
                    const HomeDayDropdown(),
                    const SizedBox(height: 16),
                    // Donut chart
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: HomeOverviewCard(),
                    ),
                    const SizedBox(height: 12),
                    // Ticker dọc lì xì nhận được
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: HomeVerticalTicker(),
                    ),
                    const SizedBox(height: 12),
                    // Ống thẻ lời chúc
                    const HomeFortuneBox(),
                    const SizedBox(height: 8),
                  ],
                ),
              );
            },
        ),
      ),
    );
  }
}
