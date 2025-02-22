import 'package:chat_model/model.dart';

class LoginDto {
  final String email;
  final Map<String, dynamic> deviceInfo;
  final String deviceId;
  final String language;
  String? pushKey;
  final RegisterMethod method;
  final String platform;
  final String password;

  LoginDto({
    required this.email,
    required this.deviceId,
    required this.language,
    required this.method,
    required this.platform,
    required this.password,
    required this.deviceInfo,
    this.pushKey,
  });

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "deviceId": deviceId,
      "deviceInfo": deviceInfo,
      "language": language,
      "pushKey": pushKey,
      "password": password,
      "method": method.name,
      "platform": platform,
    };
  }
}
