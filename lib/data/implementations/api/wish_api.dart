import '../../dtos/wish/wish_dto.dart';
import '../../interfaces/api/iwish_api.dart';
import '../local/app_database.dart';

class WishApi implements IWishApi {
  final AppDatabase _db;
  WishApi(this._db);

  @override
  Future<List<WishDTO>> getAll() async {
    final db = await _db.database;
    final maps = await db.query('wishes');
    return maps.map(WishDTO.fromMap).toList();
  }

  @override
  Future<WishDTO?> getById(int id) async {
    final db = await _db.database;
    final maps = await db.query('wishes', where: 'id=?', whereArgs: [id]);
    return maps.isEmpty ? null : WishDTO.fromMap(maps.first);
  }
}
