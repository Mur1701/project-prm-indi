// ============================================================
// Dependency Injection: wire toàn bộ DB→API→Mapper→Repo→ViewModel
// Thứ tự: DB → Api → Mapper → Repository → ViewModel
// ============================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/implementations/api/relative_api.dart';
import 'data/implementations/api/transaction_api.dart';
import 'data/implementations/api/wish_api.dart';
import 'data/implementations/local/app_database.dart';
import 'data/implementations/mapper/relative_mapper.dart';
import 'data/implementations/mapper/transaction_mapper.dart';
import 'data/implementations/repositories/relative_repository.dart';
import 'data/implementations/repositories/transaction_repository.dart';
import 'data/implementations/repositories/wish_repository.dart';
import 'viewmodels/relative_viewmodel/relative_viewmodel.dart';
import 'viewmodels/transaction_viewmodel/transaction_viewmodel.dart';
import 'viewmodels/wish_viewmodel/wish_viewmodel.dart';
import 'viewmodels/zodiac_viewmodel/zodiac_viewmodel.dart';

Widget setupDI({required Widget child}) {
  final db = AppDatabase.instance;

  // API layer
  final relativeApi    = RelativeApi(db);
  final transactionApi = TransactionApi(db);
  final wishApi        = WishApi(db);

  // Mapper layer
  final relativeMapper    = RelativeMapper();
  final transactionMapper = TransactionMapper();

  // Repository layer
  final relativeRepo    = RelativeRepository(relativeApi, relativeMapper);
  final transactionRepo = TransactionRepository(transactionApi, transactionMapper);
  final wishRepo        = WishRepository(wishApi);

  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ZodiacViewModel()),
      ChangeNotifierProvider(create: (_) => RelativeViewModel(relativeRepo)),
      ChangeNotifierProvider(create: (_) => TransactionViewModel(transactionRepo)),
      ChangeNotifierProvider(create: (_) => WishViewModel(wishRepo)),
    ],
    child: child,
  );
}
