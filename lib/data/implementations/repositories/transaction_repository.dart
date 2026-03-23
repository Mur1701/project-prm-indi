import '../../../domain/entities/transaction.dart';
import '../../../domain/enums/transaction_type_enum.dart';
import '../../dtos/transaction/insert_transaction_request_dto.dart';
import '../../dtos/transaction/transaction_dto.dart';
import '../../dtos/transaction/update_transaction_request_dto.dart';
import '../../interfaces/api/itransaction_api.dart';
import '../../interfaces/mapper/imapper.dart';
import '../../interfaces/repositories/itransaction_repository.dart';

class TransactionRepository implements ITransactionRepository {
  final ITransactionApi _api;
  final IMapper<TransactionDTO, Transaction> _mapper;

  TransactionRepository(this._api, this._mapper);

  @override
  Future<List<Transaction>> getAll() async {
    final dtos = await _api.getAll();
    return dtos.map((dto) => _mapper.map(dto)).toList();
  }

  @override
  Future<List<Transaction>> getByRelativeId(int relativeId) async {
    final dtos = await _api.getByRelativeId(relativeId);
    return dtos.map((dto) => _mapper.map(dto)).toList();
  }

  @override
  Future<Transaction> create(
    double amount,
    TransactionType type,
    int relativeId,
    String date,
    String note,
  ) async {
    // 1. Tạo request DTO
    final req = InsertTransactionRequestDTO(
      amount: amount,
      type: type,
      relativeId: relativeId,
      date: date,
      note: note,
    );
    // 2. Gọi API, lấy id mới
    final newId = await _api.create(req);
    // 3. Trả về entity tạm bằng cách build trực tiếp (tránh thêm 1 lần query)
    return Transaction(
      id: newId,
      amount: amount,
      type: type,
      relativeId: relativeId,
      date: date,
      note: note,
    );
  }

  @override
  Future<void> update(int id, double amount, String date, String note) async {
    final req = UpdateTransactionRequestDTO(
      id: id,
      amount: amount,
      date: date,
      note: note,
    );
    await _api.update(req);
  }

  @override
  Future<void> delete(int id) async {
    await _api.delete(id);
  }
}
