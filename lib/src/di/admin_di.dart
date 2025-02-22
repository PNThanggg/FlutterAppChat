import 'package:get_it/get_it.dart';

import '../modules/admin/admin.dart';
import '../modules/admin/screen/staff/all_staff_controller.dart';
import '../modules/admin/screen/telegram/tab/all_tab_controller.dart';
import '../modules/admin/screen/violation/controller/violation_controller.dart';

abstract class AdminDI {
  static void inject() {
    GetIt.I.registerSingleton<SAdminApiService>(
      SAdminApiService.init(),
    );

    GetIt.I.registerSingleton<ViolationApiService>(
      ViolationApiService.init(),
    );

    GetIt.I.registerLazySingleton<AllTabController>(
      () => AllTabController(),
    );

    GetIt.I.registerLazySingleton<ViolationController>(
      () => ViolationController(),
    );

    GetIt.I.registerLazySingleton<AllStaffController>(
      () => AllStaffController(
        GetIt.I.get<SAdminApiService>(),
      ),
    );
  }

  static void uninject() {
    GetIt.I.unregister<SAdminApiService>();
    GetIt.I.unregister<ViolationApiService>();
    GetIt.I.unregister<AllTabController>();
    GetIt.I.unregister<ViolationController>();
    GetIt.I.unregister<AllStaffController>();
  }
}
