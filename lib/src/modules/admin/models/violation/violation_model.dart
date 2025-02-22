class ViolationModel {
  ViolationModel({
    required this.text,
    required this.isActive,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? text;
  final bool? isActive;
  final String? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  ViolationModel copyWith({
    String? text,
    bool? isActive,
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return ViolationModel(
      id: id ?? this.id,
      text: text ?? this.text,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  factory ViolationModel.empty() {
    return ViolationModel(
      text: '',
      isActive: false,
      id: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      v: 0,
    );
  }

  factory ViolationModel.fromJson(Map<String, dynamic> json) {
    return ViolationModel(
      id: json["_id"],
      text: json["text"],
      isActive: json["isActive"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "text": text,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };

  @override
  String toString() {
    return "$text, $isActive, $id, $createdAt, $updatedAt, $v, ";
  }
}
