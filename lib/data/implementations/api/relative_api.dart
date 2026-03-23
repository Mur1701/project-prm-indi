import '../../dtos/relative/insert_relative_request_dto.dart';
import '../../dtos/relative/relative_dto.dart';
import '../../interfaces/api/irelative_api.dart';
import '../local/app_database.dart';

class RelativeApi implements IRelativeApi {
  final AppDatabase _db;

  RelativeApi(this._db);

  @override
  Future<List<RelativeDTO>> getAll() async {
    final db = await _db.database;
    final maps = await db.query('relatives');
    // Chuyển từng Map thành RelativeDTO
    return maps.map((m) => RelativeDTO.fromMap(m)).toList();
  }

  @override
  Future<RelativeDTO?> getById(int id) async {
    final db = await _db.database;
    final maps = await db.query(
      'relatives',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return RelativeDTO.fromMap(maps.first);
  }

  @override
  Future<int> create(InsertRelativeRequestDTO req) async {
    final db = await _db.database;
    // Insert trả về id của dòng mới tạo
    return db.insert('relatives', {
      'name': req.name,
      'group_type': req.group.value, // lưu dạng "Gia đình" / "Họ hàng" / "Thân quen"
    });
  }

  @override
  Future<int> delete(int id) async {
    final db = await _db.database;
    // Xóa luôn cả transaction liên quan để tránh dữ liệu mồ côi
    await db.delete('transactions', where: 'relative_id = ?', whereArgs: [id]);
    return db.delete('relatives', where: 'id = ?', whereArgs: [id]);
  }
}
