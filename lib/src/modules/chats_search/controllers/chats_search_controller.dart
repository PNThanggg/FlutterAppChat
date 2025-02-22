import 'package:chat_core/chat_core.dart';
import 'package:chat_sdk_core/chat_sdk_core.dart';
import 'package:flutter/cupertino.dart';

class ChatsSearchController extends SLoadingController<List<VRoom>> {
  ChatsSearchController() : super(LoadingState([]));
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  @override
  void onInit() {
    searchFocusNode.requestFocus();
  }

  @override
  void onClose() {
    searchController.dispose();
    searchFocusNode.dispose();
  }

  void onSearch(String query) async {
    if (query.isEmpty) {
      value.data = [];
      return;
    }
    vSafeApiCall<List<VRoom>>(
      onLoading: () {
        setStateLoading();
      },
      request: () async {
        return VChatController.I.nativeApi.local.room.searchRoom(text: query);
      },
      onSuccess: (response) {
        value.data = response;
        setStateSuccess();
      },
      onError: (_, __) {
        setStateError();
      },
      ignoreTimeoutAndNoInternet: true,
    );
  }

  void onRoomItemPress(VRoom vRoom, BuildContext context) {
    VChatController.I.vNavigator.messageNavigator.toMessagePage(
      context,
      vRoom,
    );
  }
}
