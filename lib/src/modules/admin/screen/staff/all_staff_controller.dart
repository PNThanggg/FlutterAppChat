import 'package:chat_core/chat_core.dart';
import 'package:chat_model/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../peer_profile/views/peer_profile_view.dart';
import '../../admin.dart';

class AllStaffController extends SLoadingController<List<SearchUser>> {
  final SAdminApiService adminApiService;

  AllStaffController(this.adminApiService)
      : super(
          LoadingState(
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
    await vSafeApiCall<List<SearchUser>>(
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

  void onItemPress(SearchUser item, BuildContext context) {
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
