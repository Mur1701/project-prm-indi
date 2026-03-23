import '../enums/relative_group_enum.dart';

class Relative {
  final int id;
  final String name;
  final RelativeGroup group;

  Relative({
    required this.id,
    required this.name,
    required this.group,
  });

  /// Lấy ký tự đầu tên để làm avatar
  String get avatarLetter => name.isNotEmpty ? name[0].toUpperCase() : '?';
}
