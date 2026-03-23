import '../../dtos/relative/relative_dto.dart';
import '../../interfaces/mapper/imapper.dart';
import '../../../domain/entities/relative.dart';
import '../../../domain/enums/relative_group_enum.dart';

class RelativeMapper implements IMapper<RelativeDTO, Relative> {
  @override
  Relative map(RelativeDTO input) {
    return Relative(
      id: input.id,
      name: input.name,
      group: RelativeGroup.fromString(input.group),
    );
  }
}
