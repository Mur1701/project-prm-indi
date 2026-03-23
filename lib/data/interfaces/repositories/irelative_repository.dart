import '../../../domain/entities/relative.dart';
import '../../../domain/enums/relative_group_enum.dart';

abstract class IRelativeRepository {
  /// Lấy toàn bộ danh sách người thân (dạng Entity)
  Future<List<Relative>> getAll();

  /// Tạo người thân mới, trả về Entity vừa tạo
  Future<Relative> create(String name, RelativeGroup group);

  /// Xóa người thân theo id
  Future<void> delete(int id);
}
