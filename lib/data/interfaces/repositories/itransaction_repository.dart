import '../../../domain/entities/transaction.dart';
import '../../../domain/enums/transaction_type_enum.dart';

abstract class ITransactionRepository {
  /// Lấy toàn bộ giao dịch
  Future<List<Transaction>> getAll();

  /// Lấy danh sách giao dịch theo relativeId
  Future<List<Transaction>> getByRelativeId(int relativeId);

  /// Tạo giao dịch mới, trả về Entity vừa tạo
  Future<Transaction> create(
    double amount,
    TransactionType type,
    int relativeId,
    String date,
    String note,
  );

  /// Cập nhật giao dịch (chỉ amount, date, note)
  Future<void> update(int id, double amount, String date, String note);

  /// Xóa giao dịch theo id
  Future<void> delete(int id);
}
