import 'package:chat_core/chat_core.dart';

class SLoadingState<T extends Object?> {
  T data;
  String? stateError;
  VChatLoadingState loadingState = VChatLoadingState.ideal;

  SLoadingState(this.data);
}
