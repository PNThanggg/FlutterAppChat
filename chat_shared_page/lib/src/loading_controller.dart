import 'package:flutter/material.dart';

import '../states.dart';

abstract class SLoadingController<T extends Object?> extends ValueNotifier<LoadingState<T>>
    implements BaseControllerAbs {
  SLoadingController(super.value);

  ChatLoadingState get loadingState => value.loadingState;

  T get data => value.data!;

  String? get stateError => value.stateError;

  @override
  void setStateLoading() {
    value.loadingState = ChatLoadingState.loading;
    notifyListeners();
  }

  @override
  void update() {
    notifyListeners();
  }

  @override
  void setStateSuccess() {
    value.loadingState = ChatLoadingState.success;
    notifyListeners();
  }

  @override
  void setStateError([String? err]) {
    value.stateError = err ?? '';
    value.loadingState = ChatLoadingState.error;
    notifyListeners();
  }

  @override
  void setStateEmpty() {
    value.loadingState = ChatLoadingState.empty;
    notifyListeners();
  }
}
