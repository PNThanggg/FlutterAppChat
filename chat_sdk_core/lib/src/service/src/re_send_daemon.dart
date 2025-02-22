import 'package:chat_sdk_core/chat_sdk_core.dart';

///this class will ensure to resend all failed messages
class ReSendDaemon with VSocketIntervalStream {
  final _messagesRef = VChatController.I.nativeApi.local.message;

  ReSendDaemon() {
    initSocketIntervalStream(
      VEventBusSingleton.vEventBus.on<VSocketIntervalEvent>(),
    );
  }

  void start() {
    onIntervalFire();
  }

  @override
  Future<void> onIntervalFire() async {
    final unSendMessages = await _messagesRef.getUnSendMessages();
    for (final message in unSendMessages) {
      if (message is VTextMessage) {
        await VMessageUploaderQueue.instance.addToQueue(
          await MessageFactory.createUploadMessage(message),
        );
      } else {
        VMessageUploaderQueue.instance.addToQueue(
          await MessageFactory.createUploadMessage(message),
        );
      }
    }
  }

  void close() {
    closeSocketIntervalStream();
  }
}
