import '../../dtos/transaction/insert_transaction_request_dto.dart';
import '../../dtos/transaction/transaction_dto.dart';
import '../../dtos/transaction/update_transaction_request_dto.dart';
import '../../interfaces/api/itransaction_api.dart';
import '../local/app_database.dart';

class TransactionApi implements ITransactionApi {
  final AppDatabase _db;

  TransactionApi(this._db);

  @override
  Future<List<TransactionDTO>> getAll() async {
    final db = await _db.database;
    // Sắp xếp theo ngày mới nhất lên đầu
    final maps = await db.query('transactions', orderBy: 'date DESC');
    return maps.map((m) => TransactionDTO.fromMap(m)).toList();
  }

  @override
  Future<List<TransactionDTO>> getByRelativeId(int relativeId) async {
    final db = await _db.database;
    final maps = await db.query(
      'transactions',
      where: 'relative_id = ?',
      whereArgs: [relativeId],
      orderBy: 'date DESC',
    );
    return maps.map((m) => TransactionDTO.fromMap(m)).toList();
  }

  @override
  Future<int> create(InsertTransactionRequestDTO req) async {
    final db = await _db.database;
    return db.insert('transactions', {
      'amount': req.amount,
      'type': req.type.value,       // "receive" hoặc "give"
      'relative_id': req.relativeId,
      'date': req.date,
      'note': req.note,
    });
  }

  @override
  Future<int> update(UpdateTransactionRequestDTO req) async {
    final db = await _db.database;
    return db.update(
      'transactions',
      {
        'amount': req.amount,
        'date': req.date,
        'note': req.note,
      },
      where: 'id = ?',
      whereArgs: [req.id],
    );
  }

  @override
  Future<int> delete(int id) async {
    final db = await _db.database;
    return db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
