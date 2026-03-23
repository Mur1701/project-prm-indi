import '../../../domain/entities/relative.dart';
import '../../../domain/enums/relative_group_enum.dart';
import '../../dtos/relative/insert_relative_request_dto.dart';
import '../../interfaces/api/irelative_api.dart';
import '../../interfaces/mapper/imapper.dart';
import '../../interfaces/repositories/irelative_repository.dart';
import '../../dtos/relative/relative_dto.dart';

class RelativeRepository implements IRelativeRepository {
  final IRelativeApi _api;
  final IMapper<RelativeDTO, Relative> _mapper;

  RelativeRepository(this._api, this._mapper);

  @override
  Future<List<Relative>> getAll() async {
    // 1. Gọi API lấy danh sách DTO từ DB
    final dtos = await _api.getAll();
    // 2. Map từng DTO → Entity rồi trả về
    return dtos.map((dto) => _mapper.map(dto)).toList();
  }

  @override
  Future<Relative> create(String name, RelativeGroup group) async {
    // 1. Tạo request DTO
    final req = InsertRelativeRequestDTO(name: name, group: group);
    // 2. Gọi API tạo mới, lấy id vừa insert
    final newId = await _api.create(req);
    // 3. Lấy lại DTO từ DB theo id mới
    final dto = await _api.getById(newId);
    if (dto == null) throw Exception('Không thể tạo người thân');
    // 4. Chuyển DTO → Entity và trả về
    return _mapper.map(dto);
  }

  @override
  Future<void> delete(int id) async {
    await _api.delete(id);
  }
}
