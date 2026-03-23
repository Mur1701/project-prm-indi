import '../../dtos/relative/insert_relative_request_dto.dart';
import '../../dtos/relative/relative_dto.dart';

abstract class IRelativeApi {
  /// Lấy toàn bộ danh sách người thân từ DB
  Future<List<RelativeDTO>> getAll();

  /// Lấy người thân theo id
  Future<RelativeDTO?> getById(int id);

  /// Tạo người thân mới, trả về id vừa tạo
  Future<int> create(InsertRelativeRequestDTO req);

  /// Xóa người thân theo id, trả về số dòng bị xóa
  Future<int> delete(int id);
}
