import 'package:chat_sdk_core/chat_sdk_core.dart';

abstract class VChatBaseHttpException extends VChatBaseException {
  // HTTP status code associated with the exception.
  final int statusCode;

  VChatBaseHttpException({
    required this.statusCode,
    required super.exception,
  });
}
