import '../../../domain/enums/relative_group_enum.dart';

class InsertRelativeRequestDTO {
  final String name;
  final RelativeGroup group;

  InsertRelativeRequestDTO({
    required this.name,
    required this.group,
  });
}
