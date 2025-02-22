import 'package:chat_model/model.dart';

class UserReport {
  final String id;
  final String content;
  final String type;
  final String createdAt;
  final BaseUser reporter;

  const UserReport({
    required this.id,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.reporter,
  });

  UserReport.empty()
      : id = "-----",
        content = "-----",
        type = "------",
        createdAt = DateTime.now().toIso8601String(),
        reporter = BaseUser.myUser;

  @override
  String toString() {
    return 'UserReport{ id: $id, content: $content, type: $type, createdAt: $createdAt, reporter: $reporter, createdAt: $createdAt,}';
  }

  UserReport copyWith({
    String? id,
    String? content,
    String? type,
    String? createdAt,
    BaseUser? reporter,
  }) {
    return UserReport(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      reporter: reporter ?? this.reporter,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'content': content,
      'type': type,
      'createdAt': createdAt,
      'uId': reporter.toMap(),
    };
  }

  factory UserReport.fromMap(Map<String, dynamic> map) {
    return UserReport(
      id: map['_id'] as String,
      content: map['content'] as String,
      type: map['type'] as String,
      createdAt: map['createdAt'] as String,
      reporter: BaseUser.fromMap(map['uId']),
    );
  }
}
