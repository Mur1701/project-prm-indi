// ============================================================
// Màn Người thân: header có con giáp lật ngang bên phải
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/enums/relative_group_enum.dart';
import '../../viewmodels/relative_viewmodel/relative_viewmodel.dart';
import '../../viewmodels/transaction_viewmodel/transaction_viewmodel.dart';
import '../../viewmodels/zodiac_viewmodel/zodiac_viewmodel.dart';
import '../shared/app_theme.dart';
import '../shared/app_widgets.dart';
import '../shared/tet_scaffold.dart';
import 'relative_form_dialog.dart';
import 'relative_group_section.dart';

class RelativePage extends StatelessWidget {
  const RelativePage({super.key});

  @override
  Widget build(BuildContext context) {
    final animal = context.watch<ZodiacViewModel>().currentAnimal;

    return TetScaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        centerTitle: false,
        title: const Text('Người thân',
            style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary, letterSpacing: -0.5)),
        actions: [
          // Con giáp lật ngang, nhìn vào bên trái
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
              child: Image.asset(
                animal.assetPath,
                width: 50, height: 50,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    Text(animal.emoji,
                        style: const TextStyle(fontSize: 32)),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<RelativeViewModel>(
          builder: (context, relVM, _) {
            if (relVM.isLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: AppTheme.red));
            }

            final txVM = context.watch<TransactionViewModel>();

            return CustomScrollView(
              slivers: [
                if (relVM.relatives.isEmpty)
                  const SliverToBoxAdapter(
                    child: EmptyState('Chưa có người thân nào\nNhấn + để thêm'),
                  )
                else
                  ...RelativeGroup.values.map((g) {
                    final members = relVM.getByGroup(g);
                    if (members.isEmpty) return const SliverToBoxAdapter();
                    return SliverToBoxAdapter(
                      child: RelativeGroupSection(
                        group: g,
                        members: members,
                        allTransactions: txVM.transactions,
                        onDelete: (id) =>
                            _confirmDelete(context, relVM, txVM, id),
                      ),
                    );
                  }),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            );
          },
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const RelativeFormDialog(),
        ),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context, RelativeViewModel relVM,
    TransactionViewModel txVM, int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xóa người thân?'),
        content: const Text('Tất cả giao dịch liên quan cũng sẽ bị xóa.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await relVM.deleteRelative(id);
      if (context.mounted) await txVM.loadTransactions();
    }
  }
}
