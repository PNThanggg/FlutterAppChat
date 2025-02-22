import 'package:chat_sdk_core/chat_sdk_core.dart';

class CallListener {
  final VNativeApi nativeApi;
  final VChatConfig vChatConfig;
  final VNavigator vNavigator;

  CallListener(
    this.nativeApi,
    this.vChatConfig,
    this.vNavigator,
  ) {
    _init();
  }

  Future<void> _init() async {
    await nativeApi.remote.socketIo.socketCompleter.future;
    VEventBusSingleton.vEventBus.on<VCallEvents>().listen((event) {
      if (event is VOnNewCallEvent) {
        return;
      }
      if (event is VCallTimeoutEvent) {
        return;
      }
      if (event is VCallAcceptedEvent) {
        return;
      }
      if (event is VCallEndedEvent) {
        return;
      }
    });
  }
}
