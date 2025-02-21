import 'package:flutter/material.dart';
import 'package:super_up_core/super_up_core.dart';

abstract class SLoadingController<T extends Object?> extends ValueNotifier<SLoadingState<T>>
    implements BaseControllerAbs {
  SLoadingController(super.value);

  VChatLoadingState get loadingState => value.loadingState;

  T get data => value.data!;

  String? get stateError => value.stateError;

  @override
  void setStateLoading() {
    value.loadingState = VChatLoadingState.loading;
    notifyListeners();
  }

  @override
  void update() {
    notifyListeners();
  }

  @override
  void setStateSuccess() {
    value.loadingState = VChatLoadingState.success;
    notifyListeners();
  }

  @override
  void setStateError([String? err]) {
    value.stateError = err ?? '';
    value.loadingState = VChatLoadingState.error;
    notifyListeners();
  }

  @override
  void setStateEmpty() {
    value.loadingState = VChatLoadingState.empty;
    notifyListeners();
  }
}
