import '../states.dart';

class LoadingState<T extends Object?> {
  T data;
  String? stateError;
  ChatLoadingState loadingState = ChatLoadingState.ideal;

  LoadingState(this.data);
}
