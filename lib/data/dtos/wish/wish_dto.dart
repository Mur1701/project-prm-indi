class WishDTO {
  final int id;
  final String title;
  final String subtitle;

  const WishDTO({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  factory WishDTO.fromMap(Map<String, dynamic> m) => WishDTO(
    id:       m['id'],
    title:    m['title'],
    subtitle: m['subtitle'],
  );

  Map<String, dynamic> toMap() => {
    'id':       id,
    'title':    title,
    'subtitle': subtitle,
  };
}
