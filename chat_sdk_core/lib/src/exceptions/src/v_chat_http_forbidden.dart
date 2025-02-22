import 'package:chat_sdk_core/chat_sdk_core.dart';

// Exception representing a 403 Forbidden HTTP response.
class VChatHttpForbidden extends VChatBaseHttpException {
  final Object vChatException; // Detailed exception message.

  VChatHttpForbidden({
    required this.vChatException,
  }) : super(
    statusCode: 403,
    exception: vChatException,
  );
}