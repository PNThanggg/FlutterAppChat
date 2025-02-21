import 'package:super_up_core/super_up_core.dart';

class SLoadingState<T extends Object?> {
  T data;
  String? stateError;
  VChatLoadingState loadingState = VChatLoadingState.ideal;

  SLoadingState(this.data);
}
