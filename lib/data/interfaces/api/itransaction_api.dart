import '../../dtos/transaction/insert_transaction_request_dto.dart';
import '../../dtos/transaction/transaction_dto.dart';
import '../../dtos/transaction/update_transaction_request_dto.dart';

abstract class ITransactionApi {
  /// Lấy toàn bộ giao dịch từ DB
  Future<List<TransactionDTO>> getAll();

  /// Lấy danh sách giao dịch theo relativeId
  Future<List<TransactionDTO>> getByRelativeId(int relativeId);

  /// Tạo giao dịch mới, trả về id vừa tạo
  Future<int> create(InsertTransactionRequestDTO req);

  /// Cập nhật giao dịch (chỉ amount, date, note), trả về số dòng bị cập nhật
  Future<int> update(UpdateTransactionRequestDTO req);

  /// Xóa giao dịch theo id giao dịch, trả về số dòng bị xóa
  Future<int> delete(int id);
}
