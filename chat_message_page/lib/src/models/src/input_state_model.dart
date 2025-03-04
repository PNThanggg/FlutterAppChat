import 'package:chat_sdk_core/chat_sdk_core.dart';

class MessageInputModel {
  VBaseMessage? replyMsg;
  bool isCloseInput;
  bool isHidden;

  MessageInputModel({
    this.replyMsg,
    this.isHidden = false,
    required this.isCloseInput,
  });

  @override
  String toString() {
    return 'InputState{replyMsg: $replyMsg, isCloseInput: $isCloseInput}';
  }
}
