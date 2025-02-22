import 'package:chat_sdk_core/chat_sdk_core.dart';

// Exception representing a 404 Not Found HTTP response.
class VChatHttpNotFound extends VChatBaseHttpException {
  final Object vChatException; // Detailed exception message.

  VChatHttpNotFound({
    required this.vChatException,
  }) : super(
          statusCode: 404,
          exception: vChatException,
        );
}
