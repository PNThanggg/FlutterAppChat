class Country {
  final String id;
  final String code;
  final String emoji;
  final String unicode;
  final String name;
  final String image;

  Country({
    required this.id,
    required this.code,
    required this.emoji,
    required this.unicode,
    required this.name,
    required this.image,
  });

  Country.empty()
      : id = "",
        code = "",
        emoji = "",
        unicode = "",
        name = "",
        image = "";

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'code': code,
      'emoji': emoji,
      'unicode': unicode,
      'name': name,
      'image': image,
    };
  }

  factory Country.fromMap(Map<String, dynamic> map) {
    return Country(
      id: map['_id'],
      code: map['code'],
      emoji: map['emoji'],
      unicode: map['unicode'],
      name: map['name'],
      image: map['image'],
    );
  }
}
