class RelativeDTO {
  final int id;
  final String name;
  final String group;

  RelativeDTO({
    required this.id,
    required this.name,
    required this.group,
  });

  /// Chuyển object thành Map để insert/update DB
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "group_type": group,
    };
  }

  /// Tạo DTO từ Map trả về từ DB
  factory RelativeDTO.fromMap(Map<String, dynamic> map) {
    return RelativeDTO(
      id: map["id"],
      name: map["name"],
      group: map["group_type"],
    );
  }
}
