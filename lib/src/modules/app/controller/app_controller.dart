import 'package:chat_core/chat_core.dart';

import '../state/app_state.dart';

class AppController extends SLoadingController<AppState> {
  AppController()
      : super(
          LoadingState(
            AppState(isAdmin: false),
          ),
        );

  bool get isAdmin => value.data.isAdmin;

  @override
  void onClose() {}

  @override
  void onInit() {}

  void updateAdmin() {
    value.data = value.data.copyWith(isAdmin: true);
  }

  void reset() {
    value.data = AppState(isAdmin: false);
  }
}
