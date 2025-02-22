import 'package:chat_sdk_core/chat_sdk_core.dart';

// Exception representing a 450 Unauthenticated HTTP response.
class VChatHttpUnAuth extends VChatBaseHttpException {
  final Object vChatException; // Detailed exception message.

  VChatHttpUnAuth({
    required this.vChatException,
  }) : super(
          statusCode: 450,
          exception: vChatException,
        );
}
