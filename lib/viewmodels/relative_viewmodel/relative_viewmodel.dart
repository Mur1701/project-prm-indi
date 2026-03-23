// ============================================================
// ViewModel quản lý state và logic cho màn Người thân
// Extends ChangeNotifier để tích hợp với Provider
// ============================================================

import 'package:flutter/foundation.dart';
import '../../data/interfaces/repositories/irelative_repository.dart';
import '../../domain/entities/relative.dart';
import '../../domain/enums/relative_group_enum.dart';
import '../../domain/validators/relative_validator.dart';

class RelativeViewModel extends ChangeNotifier {
  final IRelativeRepository _repository;

  RelativeViewModel(this._repository);

  // ── State ─────────────────────────────────────────────────
  List<Relative> _relatives = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _lastError;
  String? get lastError => _lastError;

  // ── Getters ───────────────────────────────────────────────
  List<Relative> get relatives => _relatives;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Lọc người thân theo nhóm
  List<Relative> getByGroup(RelativeGroup group) =>
      _relatives.where((r) => r.group == group).toList();

  /// Lấy toàn bộ danh sách người thân từ repository
  Future<void> loadRelatives() async {
    _setLoading(true);
    try {
      _relatives = await _repository.getAll();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Không thể tải danh sách người thân: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Thêm người thân mới rồi reload danh sách
  Future<bool> addRelative(String name, RelativeGroup group) async {
    final v = RelativeValidator.validateName(name);
    if (!v.isValid) {
      _lastError = v.error;
      notifyListeners();
      return false;
    }
    try {
      await _repository.create(name, group);
      await loadRelatives(); // Reload để cập nhật list
      return true;
    } catch (e) {
      _errorMessage = 'Không thể thêm người thân: $e';
      notifyListeners();
      return false;
    }
  }

  /// Xóa người thân theo id rồi reload danh sách
  Future<bool> deleteRelative(int id) async {
    try {
      await _repository.delete(id);
      // Xóa trực tiếp trong list local thay vì query lại DB (nhanh hơn)
      _relatives.removeWhere((r) => r.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Không thể xóa người thân: $e';
      notifyListeners();
      return false;
    }
  }

  // ── Helper ────────────────────────────────────────────────
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
