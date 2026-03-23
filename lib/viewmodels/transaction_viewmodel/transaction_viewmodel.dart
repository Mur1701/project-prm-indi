// ============================================================
// Quản lý state giao dịch: filter theo năm + ngày Tết
// Năm được sync từ ZodiacViewModel khi user đổi dropdown
// ============================================================

import 'package:flutter/foundation.dart';
import '../../data/interfaces/repositories/itransaction_repository.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/enums/transaction_type_enum.dart';
import '../../domain/validators/transaction_validator.dart';

class TransactionViewModel extends ChangeNotifier {
  final ITransactionRepository _repository;
  TransactionViewModel(this._repository);

  // ── State ─────────────────────────────────────────────────
  List<Transaction> _transactions = [];
  bool   _isLoading     = false;
  int    _selectedYear  = 2026; // sync với ZodiacViewModel
  DateTime? _selectedDate;
  String? _lastError;
  String? get lastError => _lastError;

  // ── Getters ───────────────────────────────────────────────
  bool get isLoading => _isLoading;
  int  get selectedYear => _selectedYear;
  List<Transaction> get transactions => _transactions;

  // Chỉ số Mùng (1-7), null = Tất cả
  int? get selectedDay {
    if (_selectedDate == null) return null;
    final d = _selectedDate!;
    if (d.year == _selectedYear && d.month == 2 &&
        d.day >= 17 && d.day <= 23) {
      return d.day - 16;
    }
    return null;
  }

  // Giao dịch đã lọc theo năm + ngày
  List<Transaction> get filteredTransactions {
    return _transactions.where((t) {
      final dt = t.dateTime;
      // Lọc theo năm
      if (dt.year != _selectedYear) return false;
      // Lọc theo ngày Tết
      if (_selectedDate == null) return true;
      return dt.month == _selectedDate!.month &&
             dt.day   == _selectedDate!.day;
    }).toList();
  }

  double get totalReceive => filteredTransactions
      .where((t) => t.type == TransactionType.receive)
      .fold(0, (s, t) => s + t.amount);

  double get totalGive => filteredTransactions
      .where((t) => t.type == TransactionType.give)
      .fold(0, (s, t) => s + t.amount);

  double get balance => totalReceive - totalGive;

  // ── Actions ───────────────────────────────────────────────

  Future<void> loadTransactions() async {
    _setLoading(true);
    try {
      _transactions = await _repository.getAll();
    } finally {
      _setLoading(false);
    }
  }

  // Đổi năm từ ZodiacViewModel → reset filter ngày
  void setYear(int year) {
    if (_selectedYear == year) return;
    _selectedYear = year;
    _selectedDate = null;
    notifyListeners();
  }

  // Chọn Mùng (1-7), null = Tất cả
  void selectDay(int? day) {
    if (day == null) {
      _selectedDate = null;
    } else {
      // Mùng 1 = 17/02, Mùng 2 = 18/02... trong năm đã chọn
      // Tết VN 2026: Mùng 1 = 17/02. Năm khác dùng cùng offset cho demo.
      _selectedDate = DateTime(_selectedYear, 2, 16 + day);
    }
    notifyListeners();
  }

  Future<bool> addTransaction({
    required double amount,
    required TransactionType type,
    required int relativeId,
    required String date,
    required String note,
  }) async {
    final v = TransactionValidator.validateCreate(
        amount: amount, relativeId: relativeId, date: date, note: note);
    if (!v.isValid) {
      _lastError = v.error;
      notifyListeners();
      return false;
    }
    try {
      final t = await _repository.create(amount, type, relativeId, date, note);
      _transactions.insert(0, t);
      notifyListeners();
      return true;
    } catch (e) {
      _lastError = 'Lỗi hệ thống: $e';
      notifyListeners();
      return false; }
  }

  Future<bool> updateTransaction({
    required int id,
    required double amount,
    required String date,
    required String note,
  }) async {
    final v = TransactionValidator.validateUpdate(
        id: id, amount: amount, date: date, note: note);
    if (!v.isValid) {
      _lastError = v.error;
      notifyListeners();
      return false;
    }
    try {
      await _repository.update(id, amount, date, note);
      final idx = _transactions.indexWhere((t) => t.id == id);
      if (idx != -1) {
        final old = _transactions[idx];
        _transactions[idx] = Transaction(
          id: old.id, amount: amount, type: old.type,
          relativeId: old.relativeId, date: date, note: note,
        );
        notifyListeners();
      }
      return true;
    } catch (e) {
      _lastError = 'Lỗi hệ thống: $e';
      notifyListeners();
      return false; }
  }

  Future<bool> deleteTransaction(int id) async {
    try {
      await _repository.delete(id);
      _transactions.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } catch (_) { return false; }
  }

  void _setLoading(bool v) { _isLoading = v; notifyListeners(); }
}
