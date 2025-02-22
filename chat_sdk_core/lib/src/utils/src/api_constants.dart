import 'package:chat_core/chat_core.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';

abstract class VAppConstants {
  static String clintVersion = "1.0.0";
  static const appName = "Chat Dev";
  static const dbName = "chatdev.db";
  static const apiVersion = "v1";
  static const dbVersion = 7;
  static const socketInterval = 10; // 10sec
  static String get baseServerIp {
    final uri = VChatController.I.vChatConfig.baseUrl;
    if (uri.hasPort) {
      //https         api.example
      return "${uri.scheme}://${uri.host}:${uri.port}";
    }
    return "${uri.scheme}://${uri.host}";
  }

  static Uri get baseUri {
    return Uri.parse("$baseServerIp/api/$apiVersion");
  }

  static SBaseUser get myProfile {
    return AppAuth.myProfile.baseUser;
  }

  static String get myId {
    return myProfile.id;
  }
}
