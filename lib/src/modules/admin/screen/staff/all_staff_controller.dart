import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:super_up_core/super_up_core.dart';

import '../../../peer_profile/views/peer_profile_view.dart';
import '../../admin.dart';

class AllStaffController extends SLoadingController<List<SSearchUser>> {
  final SAdminApiService adminApiService;

  AllStaffController(this.adminApiService)
      : super(
          SLoadingState(
            [],
          ),
        );

  bool isFinishLoadMore = false;

  @override
  void onClose() {}

  @override
  void onInit() {
    getData();
  }

  Future<void> getData() async {
    await vSafeApiCall<List<SSearchUser>>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        return await adminApiService.getAllStaff();
      },
      onSuccess: (response) {
        value.data = response;

        setStateSuccess();
      },
      onError: (exception, trace) {
        if (kDebugMode) {
          print("GET_ALL_STAFF: $exception");
          print("GET_ALL_STAFF: ${trace.toString()}");
        }
      },
    );
  }

  void onItemPress(SSearchUser item, BuildContext context) {
    debugPrint("ALL_STAFF_CONTROLLER:: ${item.toString()}");

    context
        .toPage(
      PeerProfileView(
        peerId: item.baseUser.id,
        isStaff: item.isStaff,
      ),
    )
        .then(
      (value) {
        getData();
      },
    );
  }
}
