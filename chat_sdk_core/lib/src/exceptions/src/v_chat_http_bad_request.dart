import 'package:chat_sdk_core/chat_sdk_core.dart';

// Exception representing a 400 Bad Request HTTP response.
class VChatHttpBadRequest extends VChatBaseHttpException {
  // Detailed exception message.
  final String vChatException;

  VChatHttpBadRequest({
    required this.vChatException,
  }) : super(
          statusCode: 400,
          exception: vChatException,
        );
}
