import 'package:super_up_core/super_up_core.dart';

import '../state/app_state.dart';

class AppController extends SLoadingController<AppState> {
  AppController()
      : super(
          SLoadingState(
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
